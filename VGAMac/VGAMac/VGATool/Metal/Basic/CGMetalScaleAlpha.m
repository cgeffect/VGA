//
//  CGMetalScaleAlpha.m
//  VGAMac
//
//  Created by Jason on 2022/1/2.
//

#import "CGMetalScaleAlpha.h"

#define kCGMetalScaleLeftAlphaFragmentShader @"kCGMetalScaleLeftAlphaFragmentShader"
#define kCGMetalScaleRightAlphaFragmentShader @"kCGMetalScaleRightAlphaFragmentShader"

@implementation CGMetalScaleAlpha

- (instancetype)initWithAlphaMode:(CGMetalAlphaMode)blendAlphaMode {
    if (blendAlphaMode == CGMetalAlphaModeLeftScaleAlpha) {
        self = [super initWithFragmentShader:kCGMetalScaleLeftAlphaFragmentShader];
    } else if (blendAlphaMode == CGMetalAlphaModeRightScaleAlpha) {
        self = [super initWithFragmentShader:kCGMetalScaleRightAlphaFragmentShader];
    }
    if (self) {

    }
    
    return self;
}

@end
