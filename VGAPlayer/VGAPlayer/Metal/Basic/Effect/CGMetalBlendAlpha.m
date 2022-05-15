//
//  CGMetalBlendAlpha.m
//  CGMetal
//
//  Created by Jason on 2021/11/19.
//

#import "CGMetalBlendAlpha.h"

#define kCGMetalLeftAlphaFragmentShader @"kCGMetalLeftAlphaFragmentShader"
#define kCGMetalRightAlphaFragmentShader @"kCGMetalRightAlphaFragmentShader"

@implementation CGMetalBlendAlpha

- (instancetype)initWithAlphaMode:(CGMetalAlphaMode)blendAlphaMode {
    if (blendAlphaMode == CGMetalAlphaModeLeftAlpha) {
        self = [super initWithFragmentShader:kCGMetalLeftAlphaFragmentShader];
    } else if (blendAlphaMode == CGMetalAlphaModeRightAlpha) {
        self = [super initWithFragmentShader:kCGMetalRightAlphaFragmentShader];
    }

    if (self) {

    }
    
    return self;
}

@end
