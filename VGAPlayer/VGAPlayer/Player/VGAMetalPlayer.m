//
//  VGAMetalPlayer.m
//  VGAPlayer
//
//  Created by Jason on 2022/1/7.
//

#import "VGAMetalPlayer.h"
#import "CGMetal.h"
#import "UIView+VGA.h"
#import "VGAMetalView.h"

@interface VGAMetalPlayer ()
@property(nonatomic, strong)CGMetalPlayerInput *videoInput;
@property(nonatomic, strong)VGAMetalView *metalView;
@end

@implementation VGAMetalPlayer

- (IVGAVideoPlayer *)initWithItem:(VGAPlayItem *)playItem {
    self = [super init];
    if (self) {
        _playItem = playItem;
        _metalView = [[VGAMetalView alloc] initWithFrame:CGRectMake(0, 0, playItem.canvasSize.width, playItem.canvasSize.height)];
    }
    return self;
}

- (void)setWrapView:(UIView *)wrapView {
    _wrapView = wrapView;
    _metalView.translatesAutoresizingMaskIntoConstraints = NO;
    [_wrapView addSubview:_metalView];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [UIView addConstraintWithView:_metalView superView:_wrapView];
    [CATransaction commit];
}

- (void)replaceVideoItem:(nonnull VGAVideoItem *)item {
    _videoItem = item;
    CGMetalContentMode contentMode = CGMetalContentModeScaleAspectFit;
    if (item.contentMode == VGAViewContentModeScaleToFill) {
        contentMode = CGMetalContentModeScaleToFill;
    } else if (item.contentMode == VGAViewContentModeScaleAspectFit) {
        contentMode = CGMetalContentModeScaleAspectFit;
    } else if (item.contentMode == VGAViewContentModeScaleAspectFill) {
        contentMode = CGMetalContentModeScaleAspectFill;
    }
    _metalView.canvasView.contentMode = contentMode;
    CGMetalAlphaMode mode = CGMetalAlphaModeNone;
    if (_playItem.alphaMode == VGAAlphaModeLeftAlpha) {
        mode = CGMetalAlphaModeLeftAlpha;
    } else if (_playItem.alphaMode == VGAAlphaModeLeftScaleAlpha) {
        mode = CGMetalAlphaModeLeftScaleAlpha;
    } else if (_playItem.alphaMode == VGAAlphaModeRightAlpha) {
        mode = CGMetalAlphaModeRightAlpha;
    } else if (_playItem.alphaMode == VGAAlphaModeRightScaleAlpha) {
        mode = CGMetalAlphaModeRightScaleAlpha;
    } else if (_playItem.alphaMode == VGAAlphaModeHevcWithAlpha) {
        mode = CGMetalAlphaModeRGBA;
    } 
    _metalView.canvasView.alphaChannelMode = mode;
}

- (void)loadResource:(nonnull NSURL *)URL {
    if (_playItem.alphaMode == VGAAlphaModeHevcWithAlpha) {
        _videoInput = [[CGMetalPlayerInput alloc] initWithURL:URL pixelFormat:CGPixelFormatBGRA];
    } else {
        _videoInput = [[CGMetalPlayerInput alloc] initWithURL:URL pixelFormat:CGPixelFormatNV12];
    }
    _videoInput.isLoopPlay = _videoItem.isLoopPlay;
    if (_playItem.alphaMode == VGAAlphaModeLeftAlpha) {
        CGMetalBlendAlpha *blend = [[CGMetalBlendAlpha alloc] initWithAlphaMode:(CGMetalAlphaModeLeftAlpha)];
        [_videoInput addTarget:blend];
        [blend addTarget:_metalView.canvasView];
    } else if (_playItem.alphaMode == VGAAlphaModeLeftScaleAlpha) {
        CGMetalBlendScaleAlpha *blend = [[CGMetalBlendScaleAlpha alloc] initWithAlphaMode:(CGMetalAlphaModeLeftScaleAlpha)];
        [_videoInput addTarget:blend];
        [blend addTarget:_metalView.canvasView];
    } else if (_playItem.alphaMode == VGAAlphaModeRightAlpha) {
        CGMetalBlendAlpha *blend = [[CGMetalBlendAlpha alloc] initWithAlphaMode:(CGMetalAlphaModeRightAlpha)];
        [_videoInput addTarget:blend];
        [blend addTarget:_metalView.canvasView];
    } else if (_playItem.alphaMode == VGAAlphaModeRightScaleAlpha) {
        CGMetalBlendScaleAlpha *blend = [[CGMetalBlendScaleAlpha alloc] initWithAlphaMode:(CGMetalAlphaModeRightScaleAlpha)];
        [_videoInput addTarget:blend];
        [blend addTarget:_metalView.canvasView];
    } else if (_playItem.alphaMode == VGAAlphaModeHevcWithAlpha) {
        CGMetalBasic *blend = [[CGMetalBasic alloc] init];
        [_videoInput addTarget:blend];
        [blend addTarget:_metalView.canvasView];
    }
    [_videoInput play];
}

- (void)destroy {
    [_videoInput stop];
    [_videoInput destroy];
    _videoInput = nil;
}

- (void)willResignActive {
    if (_videoItem.backgroundMode == VGABackgroundModeStop) {
        [self destroy];
        if (_metalView) {
            [_metalView removeFromSuperview];
            _metalView = nil;
        }
    } else if (_videoItem.backgroundMode == VGABackgroundModePauseAndResume) {
        [_videoInput pause];
    } else if (_videoItem.backgroundMode == VGABackgroundModeStopAndPlay) {
        [_videoInput stop];
    }
}

- (void)didBecomeActive {
    if (_videoItem.backgroundMode == VGABackgroundModeStop) {
        [self destroy];
    } else if (_videoItem.backgroundMode == VGABackgroundModePauseAndResume) {
        [_videoInput resume];
    } else if (_videoItem.backgroundMode == VGABackgroundModeStopAndPlay) {
        [_videoInput play];
    }
}

- (void)dealloc {
    NSLog(@"%@ dealloc", self);
}

@end
