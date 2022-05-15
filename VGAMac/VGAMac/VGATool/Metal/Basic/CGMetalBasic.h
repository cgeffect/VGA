//
//  CGMetalBasic.h
//  CGMetal
//
//  Created by Jason on 2021/5/13.
//  Copyright © 2021 CGMetal. All rights reserved.
//

@import Foundation;
@import Metal;

#import "CGMetalInput.h"
#import "CGMetalOutput.h"
#import "CGMetalRender.h"

NS_ASSUME_NONNULL_BEGIN

typedef struct _vec_float1 {
    float x;
} vec_float1;

typedef struct _vec_float2 {
    float x;
    float y;
} vec_float2;

typedef struct _vec_float3 {
    float x;
    float y;
    float z;
} vec_float3;

typedef struct _vec_float4 {
    float x;
    float y;
    float z;
    float w;
} vec_float4;

@interface CGMetalBasic : CGMetalOutput<CGMetalInput, CGMetalRenderEvent>
{
@protected
    float _inValue;
}

#pragma mark -
#pragma mark Init
- (instancetype)initWithVertexShader:(NSString *)vertexShader
                      fragmentShader:(NSString *)fragmentShader;

- (instancetype)initWithVertexShader:(NSString *)vertexShader;

- (instancetype)initWithFragmentShader:(NSString *)fragmentShader;

@property(nonatomic, assign, readonly)CGSize inTextureSize;
@property(nonatomic, assign, readonly)CGSize outTextureSize;

#pragma mark -
#pragma mark Render
//render with Vertex Texture coordinates
- (void)renderToTextureWithVertices:(const float *)vertices
                 textureCoordinates:(const float *)textureCoordinates;

//notify next filter to render
- (void)notifyNextTargetsAboutNewTexture:(CGMetalTexture *)outTexture;

#pragma mark -
#pragma mark setter
- (void)setInValue:(CGFloat)inValue;
//Vertex
- (void)setVertexValue:(float)value index:(int)index;
//- (void)setVertexValue2:(simd_float2)value index:(int)index;
//- (void)setVertexValue3:(simd_float3)value index:(int)index;
//- (void)setVertexValue4:(simd_float4)value index:(int)index;
//Fragment
- (void)setFragmentValue:(float)value index:(int)index;
//- (void)setFragmentValue2:(simd_float2)value index:(int)index;
//- (void)setFragmentValue3:(simd_float3)value index:(int)index;
//- (void)setFragmentValue4:(simd_float4)value index:(int)index;
//Texture
- (void)setFragmentTexture:(nonnull id <MTLTexture>)texture index:(int)index;

#pragma mark -
#pragma mark getter
- (float *)getVertices;
- (float *)getTextureCoordinates;
- (CGSize)getTextureSize;
@end

NS_ASSUME_NONNULL_END
