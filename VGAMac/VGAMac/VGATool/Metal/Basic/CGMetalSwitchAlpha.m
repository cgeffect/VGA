//
//  CGMetalSwitchAlpha.m
//  VGAMac
//
//  Created by Jason on 2022/1/12.
//

#import "CGMetalSwitchAlpha.h"

#define kCGMetalLeftToRightAlphaFragmentShader @"kCGMetalLeftToRightAlphaFragmentShader"
#define kCGMetalRightToLeftAlphaFragmentShader @"kCGMetalRightToLeftAlphaFragmentShader"

@implementation CGMetalSwitchAlpha

- (instancetype)initWithAlphaMode:(CGMetalAlphaMode)blendAlphaMode {
    if (blendAlphaMode == CGMetalAlphaModeLeftAlpha) {
        self = [super initWithFragmentShader:kCGMetalRightToLeftAlphaFragmentShader];
    } else if (blendAlphaMode == CGMetalAlphaModeRightAlpha) {
        self = [super initWithFragmentShader:kCGMetalLeftToRightAlphaFragmentShader];
    }
    if (self) {

    }
    
    return self;
}
@end
