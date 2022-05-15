//
//  VGAPreviewController.m
//  VGAMac
//
//  Created by Jason on 2021/12/3.
//

#import "VGAPreviewController.h"
#import "CGMetal.h"

@interface VGAPreviewController ()
{
    CGMetalPlayerInputMac *_leftSource;
    CGMetalPlayerInputMac *_rightSource;
}
@end

@implementation VGAPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预览";
    self.view.layer.backgroundColor = NSColor.blueColor.CGColor;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showLeft];
        [self showRight];
        
        NSButton *btn = [NSButton buttonWithTitle:@"pause" target:self action:@selector(toggle:)];
        btn.frame = CGRectMake((self.view.frame.size.width / 2) - 50, 10, 100, 100);
        [self.view addSubview:btn];
    });
}

- (void)showLeft {
    if (_srcPath == nil || _srcPath.length == 0) {
        return;
    }
    CGMetalNSViewOutput *metalView = [[CGMetalNSViewOutput alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width / 2, self.view.frame.size.height - 100)];
    metalView.layer.backgroundColor = NSColor.clearColor.CGColor;
    [self.view addSubview:metalView];

    CGMetalBasic *filter;
    if (_inputMode == VGAInputAlphaModeRGBA) {
        metalView.alphaChannelMode = CGMetalAlphaModeRGBA;
        filter = [[CGMetalBasic alloc] init];
    } else if (_inputMode == VGAInputAlphaModeLeftAlpha) {
        metalView.alphaChannelMode = CGMetalAlphaModeLeftAlpha;
        filter = [[CGMetalBlendAlpha alloc] initWithAlphaMode:CGMetalAlphaModeLeftAlpha];
    } else if (_inputMode == VGAInputAlphaModeRightAlpha) {
        metalView.alphaChannelMode = CGMetalAlphaModeRightAlpha;
        filter = [[CGMetalBlendAlpha alloc] initWithAlphaMode:CGMetalAlphaModeRightAlpha];
    }
    
    _leftSource = [[CGMetalPlayerInputMac alloc] initWithURL:[NSURL fileURLWithPath:_srcPath]];
    [_leftSource addTarget:filter];
    [filter addTarget:metalView];
    [_leftSource requestRender];
}

- (void)showRight {
    if (_dstPath == nil || _dstPath.length == 0) {
        return;
    }
    CGMetalLayerOutput *metalLayer = [[CGMetalLayerOutput alloc] initWithScale:NSScreen.mainScreen.backingScaleFactor];
    metalLayer.frame = CGRectMake(self.view.frame.size.width / 2, 100, self.view.frame.size.width / 2, self.view.frame.size.height - 100);
    metalLayer.backgroundColor = NSColor.clearColor.CGColor;
    [self.view.layer addSublayer:metalLayer];

    CGMetalBasic *filter;
    if (_outputMode == VGAOutputAlphaModeLeftAlpha) {
        metalLayer.alphaChannelMode = CGMetalAlphaModeLeftAlpha;
        filter = [[CGMetalBlendAlpha alloc] initWithAlphaMode:CGMetalAlphaModeLeftAlpha];
    } else if (_outputMode == VGAOutputAlphaModeRightAlpha) {
        metalLayer.alphaChannelMode = CGMetalAlphaModeRightAlpha;
        filter = [[CGMetalBlendAlpha alloc] initWithAlphaMode:CGMetalAlphaModeRightAlpha];
    } else if (_outputMode == VGAOutputAlphaModeLeftScaleAlpha) {
        metalLayer.alphaChannelMode = CGMetalAlphaModeLeftScaleAlpha;
        filter = [[CGMetalBlendScaleAlpha alloc] initWithAlphaMode:CGMetalAlphaModeLeftScaleAlpha];
    } else if (_outputMode == VGAOutputAlphaModeRightScaleAlpha) {
        metalLayer.alphaChannelMode = CGMetalAlphaModeRightScaleAlpha;
        filter = [[CGMetalBlendScaleAlpha alloc] initWithAlphaMode:CGMetalAlphaModeRightScaleAlpha];
    } else if (_outputMode == VGAOutputAlphaModeHevcWithAlpha) {
        metalLayer.alphaChannelMode = CGMetalAlphaModeRGBA;
        filter = [[CGMetalBasic alloc] init];
    }
    
    _rightSource = [[CGMetalPlayerInputMac alloc] initWithURL:[NSURL fileURLWithPath:_dstPath]];
    [_rightSource addTarget:filter];
    [filter addTarget:metalLayer];
    [_leftSource requestRender];
}

- (void)toggle:(NSButton *)btn {
    if ([btn.title isEqualToString:@"play"]) {
        [btn setTitle:@"pause"];
        [_leftSource resume];
        [_rightSource resume];
    } else if ([btn.title isEqualToString:@"pause"]){
        [btn setTitle:@"play"];
        [_leftSource pause];
        [_rightSource pause];
    }
}
- (void)dealloc
{
    [_leftSource stop];
    [_rightSource stop];
}
@end

