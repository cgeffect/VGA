//
//  VGAVideoEncoder.m
//  VGAMac
//
//  Created by Jason on 2021/11/30.
//

#import "VGAConvertEncoder.h"
#import "CGMetal.h"
#import "CGMetalVideoOutput.h"
#import "VGAVideoInfo.h"
#import "NSAlertView.h"

@interface VGAConvertEncoder ()<CGMetalVideoReadDelegate>
{
    CGMetalVideoOutput *_surfaceOutput;
    CGMetalVideoInput *_readerInput;
}
@end

/*
 音视频合并
 左右互转
 删除metal源文件, 只保留metal.deafultlib
 看下蓝牙问题
 */
@implementation VGAConvertEncoder

- (instancetype)init
{
    self = [super init];
    if (self) {
        _qualityForAlpha = 0.5;
    }
    return self;
}

- (void)gotoEncode:(NSURL *)srcUrl outUrl:(NSURL *)outUrl {
    _readerInput = [[CGMetalVideoInput alloc] initWithURL:srcUrl pixelFormat:CGPixelFormatBGRA];
    _readerInput.delegate = self;
    _surfaceOutput = [[CGMetalVideoOutput alloc] initWithVideoURL:outUrl fileType:AVFileTypeQuickTimeMovie outputSettings:nil];
    VGAVideoInfo *videoInfo = [[VGAVideoInfo alloc] initWithPath:srcUrl.relativePath];
    
    CGMetalBasic *basic;
    CGMetalCrop *_cropFilter;
    if (_inputMode == VGAInputAlphaModeRGBA) {
        if (_outputMode == VGAOutputAlphaModeLeftAlpha) {
            videoInfo.width = videoInfo.width * 2;
            videoInfo.codecMode = AVTVideoCodecModeAVC;
            basic = [[CGMetalScaleARGBAlpha alloc] initWithAlphaMode:(CGMetalAlphaModeLeftAlpha)];
        } else if (_outputMode == VGAOutputAlphaModeRightAlpha) {
            videoInfo.width = videoInfo.width * 2;
            videoInfo.codecMode = AVTVideoCodecModeAVC;
            basic = [[CGMetalScaleARGBAlpha alloc] initWithAlphaMode:(CGMetalAlphaModeRightAlpha)];
        } else if (_outputMode == VGAOutputAlphaModeLeftScaleAlpha) {
            videoInfo.codecMode = AVTVideoCodecModeAVC;
            videoInfo.width = videoInfo.width / 2 * 3;
            basic = [[CGMetalScaleARGBAlpha alloc] initWithAlphaMode:(CGMetalAlphaModeLeftScaleAlpha)];
        } else if (_outputMode == VGAOutputAlphaModeRightScaleAlpha) {
            videoInfo.codecMode = AVTVideoCodecModeAVC;
            videoInfo.width = videoInfo.width / 2 * 3;
            basic = [[CGMetalScaleARGBAlpha alloc] initWithAlphaMode:(CGMetalAlphaModeRightScaleAlpha)];
        } else if (_outputMode == VGAOutputAlphaModeHevcWithAlpha) {
            videoInfo.codecMode = AVTVideoCodecModeHevcWithAlpha;
            basic = [[CGMetalBasic alloc] init];
        }
    } else if (_inputMode == VGAInputAlphaModeLeftAlpha) {
        if (_outputMode == VGAOutputAlphaModeLeftScaleAlpha) {
            videoInfo.width = videoInfo.width / 4 * 3;
            videoInfo.codecMode = AVTVideoCodecModeAVC;
            _cropFilter = [[CGMetalCrop alloc] init];
            [_cropFilter setCropRegion:CGRectMake(0, 0, 0.75, 1)];
            basic = [[CGMetalScaleAlpha alloc] initWithAlphaMode:(CGMetalAlphaModeLeftScaleAlpha)];
        } else if (_outputMode == VGAOutputAlphaModeHevcWithAlpha) {
            videoInfo.width = videoInfo.width / 2;
            videoInfo.codecMode = AVTVideoCodecModeHevcWithAlpha;
            basic = [[CGMetalBlendAlpha alloc] initWithAlphaMode:(CGMetalAlphaModeLeftAlpha)];
        } else if (_outputMode == VGAOutputAlphaModeRightAlpha) {
            videoInfo.codecMode = AVTVideoCodecModeAVC;
            basic = [[CGMetalSwitchAlpha alloc] initWithAlphaMode:(CGMetalAlphaModeRightAlpha)];
        } else {
            NSString *message = @"LeftAlpha仅支持LeftScaleAlpha,HevcWithAlpha";
            [NSAlertView alertView:message confirm:^{
                            
            } cancel:^{
                
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate videoEncode:self notSupport:YES];
            });
            return;
        }
    } else if (_inputMode == VGAInputAlphaModeRightAlpha) {
        if (_outputMode == VGAOutputAlphaModeRightScaleAlpha) {
            videoInfo.width = videoInfo.width / 4 * 3;
            videoInfo.codecMode = AVTVideoCodecModeAVC;
            _cropFilter = [[CGMetalCrop alloc] init];
            [_cropFilter setCropRegion:CGRectMake(0, 0, 0.75, 1)];
            basic = [[CGMetalScaleAlpha alloc] initWithAlphaMode:(CGMetalAlphaModeRightScaleAlpha)];
        } else if (_outputMode == VGAOutputAlphaModeHevcWithAlpha) {
            videoInfo.width = videoInfo.width / 2;
            videoInfo.codecMode = AVTVideoCodecModeHevcWithAlpha;
            basic = [[CGMetalBlendAlpha alloc] initWithAlphaMode:(CGMetalAlphaModeRightAlpha)];
        } else if (_outputMode == VGAOutputAlphaModeLeftAlpha) {
            videoInfo.codecMode = AVTVideoCodecModeAVC;
            basic = [[CGMetalSwitchAlpha alloc] initWithAlphaMode:(CGMetalAlphaModeLeftAlpha)];
        } else {
            NSString *message = @"RightAlpha仅支持RightScaleAlpha,HevcWithAlpha";
            [NSAlertView alertView:message confirm:^{
                            
            } cancel:^{
                
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate videoEncode:self notSupport:YES];
            });
            return;
        }
    }
    
    _surfaceOutput.videoInfo = videoInfo;
    _surfaceOutput.videoInfo.bitRate = _surfaceOutput.videoInfo.width * _surfaceOutput.videoInfo.height * 5;

    if (_width > 0 && _height > 0) {
        _surfaceOutput.videoInfo.width = _width;
        _surfaceOutput.videoInfo.height = _height;
    }
    
    if (_averageBitRate > 0) {
        _surfaceOutput.videoInfo.bitRate = _averageBitRate;
    }
    
    if (_qualityForAlpha > 0 && _qualityForAlpha <= 1) {
        _surfaceOutput.videoInfo.qualityForAlpha = _qualityForAlpha;
    }
    
    [_readerInput addTarget:basic];
    if (_cropFilter) {
        [basic addTarget:_cropFilter];
        [_cropFilter addTarget:_surfaceOutput];
    } else {
        [basic addTarget:_surfaceOutput];
    }
    [_readerInput requestRender];
}

//CGMetalVideoReadDelegate
- (void)videoReader:(CGMetalVideoInput *)videoEncoder onProgress:(float)progress {
    [self.delegate videoEncode:self progress:progress];
}

- (void)didCompletePlayingMovie {
    
}


- (void)dealloc {

}

@end
