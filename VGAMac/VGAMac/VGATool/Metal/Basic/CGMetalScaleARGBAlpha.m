//
//  CGMetalScaleARGBAlpha.m
//  CGMetalMac
//
//  Created by Jason on 2022/1/6.
//

#import "CGMetalScaleARGBAlpha.h"
#define kCGMetalScaleLeftAlphaWithARGBFragmentShader @"kCGMetalScaleLeftAlphaWithARGBFragmentShader"
#define kCGMetalScaleRightAlphaWithARGBFragmentShader @"kCGMetalScaleRightAlphaWithARGBFragmentShader"
#define kCGMetalLeftAlphaWithARGBFragmentShader @"kCGMetalLeftAlphaWithARGBFragmentShader"
#define kCGMetalRightAlphaWithARGBFragmentShader @"kCGMetalRightAlphaWithARGBFragmentShader"

@implementation CGMetalScaleARGBAlpha
{
    CGMetalAlphaMode _blendAlphaMode;
}
- (instancetype)initWithAlphaMode:(CGMetalAlphaMode)blendAlphaMode {
    _blendAlphaMode = blendAlphaMode;
    if (blendAlphaMode == CGMetalAlphaModeLeftScaleAlpha) {
        self = [super initWithFragmentShader:kCGMetalScaleLeftAlphaWithARGBFragmentShader];
    } else if (blendAlphaMode == CGMetalAlphaModeRightScaleAlpha) {
        self = [super initWithFragmentShader:kCGMetalScaleRightAlphaWithARGBFragmentShader];
    } else if (blendAlphaMode ==CGMetalAlphaModeLeftAlpha) {
        self = [super initWithFragmentShader:kCGMetalLeftAlphaWithARGBFragmentShader];
    } else if (blendAlphaMode ==CGMetalAlphaModeRightAlpha) {
        self = [super initWithFragmentShader:kCGMetalRightAlphaWithARGBFragmentShader];
    }
    if (self) {

    }
    
    return self;

}

- (CGSize)getTextureSize {
    if (_blendAlphaMode == CGMetalAlphaModeLeftAlpha || _blendAlphaMode == CGMetalAlphaModeRightAlpha) {
        return CGSizeMake(self.inTextureSize.width * 2, self.inTextureSize.height);
    }
    return CGSizeMake(self.inTextureSize.width / 2 * 3, self.inTextureSize.height);
}

//为啥重写就不行了? 协议里的属性导致的?
//- (void)newTextureAvailable:(CGMetalTexture *)inTexture {
//    _inTexture = inTexture;
//    [self newTextureInput:_inTexture];
//
//    id<MTLTexture> texture = [_outTexture newTexture:MTLPixelFormatRGBA8Unorm size:CGSizeMake(inTexture.textureSize.width / 2 * 3, inTexture.textureSize.height) usege:MTLTextureUsageShaderRead | MTLTextureUsageRenderTarget];
//
//    //set render target texture, MTLTexture can be reuse
//    [_mtlRender setOutTexture:texture
//                           index:0];
//    [self renderToTextureWithVertices:self.getVertices
//                   textureCoordinates:self.getTextureCoordinates];
//    [self notifyNextTargetsAboutNewTexture:_outTexture];
//}

@end
