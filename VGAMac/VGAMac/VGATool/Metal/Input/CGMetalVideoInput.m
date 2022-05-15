//
//  CGMetalVideoReaderInput.m
//  CGMetal
//
//  Created by Jason on 2021/12/1.
//

#import "CGMetalVideoInput.h"
#import "VGAVideoDecoder.h"
#import "CGMetalPixelBufferInput.h"

@interface CGMetalVideoInput ()
{
    CGPixelFormat _pixelFormat;
    BOOL _isFinished;
    int _maxFrameCount;
}
@property(nonatomic, strong)NSString *videoPath;
@property(nonatomic, strong)VGAVideoInfo *videoInfo;
@property(nonatomic, strong)VGAVideoDecoder *videoReader;
@property(nonatomic, strong)CGMetalOutput *output;
@end

@implementation CGMetalVideoInput

- (instancetype)initWithURL:(NSURL *)url pixelFormat:(CGPixelFormat)pixelFormat {
    self = [super init];
    if (self) {
        _videoPath = url.relativePath;
        _pixelFormat = pixelFormat;
        _videoReader = [[VGAVideoDecoder alloc] init];
        [_videoReader loadResource:_videoPath];
        _videoInfo = _videoReader.videoInfo;
        _maxFrameCount = _videoInfo.frameRate * (_videoInfo.durationMs / 1000);

    }
    return self;
}

- (void)requestRender {
    [_videoReader copyNextPixelBuffer:^(CVPixelBufferRef  _Nullable pixelBuffer, NSInteger index, CMTime frameTime) {
        @autoreleasepool {
            if (pixelBuffer != NULL) {
                if (self->_output == nil) {
                    self->_output = [[CGMetalPixelBufferInput alloc] initWithFormat:self->_pixelFormat];
                    [((CGMetalPixelBufferInput *)self->_output) uploadPixelBuffer:pixelBuffer];
                } else {
                    [(CGMetalPixelBufferInput *)self->_output updatePixelBuffer:pixelBuffer];
                }
                [self _requestRender:frameTime];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.delegate && [self.delegate respondsToSelector:@selector(videoReader:onProgress:)]) {
                    [self.delegate videoReader:self onProgress:(float)index / self->_maxFrameCount];
                }
            });
        }
    } finishHandler:^(BOOL isCancel) {
        if (isCancel) {
            self->_isFinished = NO;
        } else {
            self->_isFinished = YES;
        }
        [self _stopRender];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(videoReader:onProgress:)]) {
                [self.delegate videoReader:self onProgress:1];
            }
        });
    }];
}

- (void)_requestRender:(CMTime)time {
    for (id<CGMetalInput> currentTarget in self->_targets) {
        [currentTarget newFrameReadyAtTime:time atIndex:0];
        [currentTarget newTextureAvailable:self->_output.outTexture];
    }
}

- (void)_stopRender {
    for (id<CGMetalInput> currentTarget in self->_targets) {
        [currentTarget stopRender:_isFinished];
    }
}

- (void)cancelReader {
    if (_isFinished == NO) {
        [_videoReader cancel];
    }
    [_videoReader destroy];
}

@end
