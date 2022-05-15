//
//  CGMetalOverlayAlpha.m
//  CGMetal
//
//  Created by Jason on 2021/11/19.
//

#import "CGMetalBlendAlpha.h"

#define kCGMetalAlphaFragmentShader @"kCGMetalAlphaFragmentShader"
#define kCGMetalAlphaFragmentShader1 @"kCGMetalAlphaFragmentShader1"

@implementation CGMetalBlendAlpha

- (instancetype)initWithAlphaMode:(CGMetalAlphaMode)blendAlphaMode {
    if (blendAlphaMode == CGMetalAlphaModeLeftAlpha) {
        self = [super initWithFragmentShader:kCGMetalAlphaFragmentShader];
    } else if (blendAlphaMode == CGMetalAlphaModeRightAlpha) {
        self = [super initWithFragmentShader:kCGMetalAlphaFragmentShader1];
    }
    if (self) {

    }
    
    return self;
}

@end
