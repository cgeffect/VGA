//
//  CGMetalBlendScaleAlpha.m
//  CGMetal
//
//  Created by Jason on 2022/1/3.
//

#import "CGMetalBlendScaleAlpha.h"

#define kCGMetalBlendScaleLeftAlphaFragmentShader @"kCGMetalBlendScaleLeftAlphaFragmentShader"

#define kCGMetalBlendScaleRightAlphaFragmentShader @"kCGMetalBlendScaleRightAlphaFragmentShader"

@implementation CGMetalBlendScaleAlpha

- (instancetype)initWithAlphaMode:(CGMetalAlphaMode)blendAlphaMode {
    if (blendAlphaMode == CGMetalAlphaModeLeftScaleAlpha) {
        self = [super initWithFragmentShader:kCGMetalBlendScaleLeftAlphaFragmentShader];
    } else if (blendAlphaMode == CGMetalAlphaModeRightScaleAlpha) {
        self = [super initWithFragmentShader:kCGMetalBlendScaleRightAlphaFragmentShader];
    }
    if (self) {

    }
    
    return self;
}

@end
