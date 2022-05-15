//
//  CGMetalOverlayAlpha.metal
//  CGMetal
//
//  Created by Jason on 2021/11/19.
//

#include "CGMetalHeader.h"
#include <metal_stdlib>
using namespace metal;

fragment float4
kCGMetalAlphaFragmentShader(VertexOut in [[ stage_in ]],
                           texture2d<float, access::sample> tex [[ texture(0) ]],
                           constant float *value [[ buffer(0) ]] ) {

    //计算视频的左边A值
    float left = in.texCoordinate.x / 2;
    float alpha = tex.sample(texSampler, float2(left, in.texCoordinate.y)).r;

    //计算视频的右边RGB值
    float tcx = in.texCoordinate.x / 2 + 0.5;
    float3 rgb = tex.sample(texSampler, float2(tcx, in.texCoordinate.y)).rgb;
    
    return float4(rgb, alpha);
    
}

fragment float4
kCGMetalAlphaFragmentShader1(VertexOut in [[ stage_in ]],
                           texture2d<float, access::sample> tex [[ texture(0) ]],
                           constant float *value [[ buffer(0) ]] ) {
    //计算视频的左边RGB部分
    float left = in.texCoordinate.x / 2;
    float3 rgb = tex.sample(texSampler, float2(left, in.texCoordinate.y)).rgb;
    
    //计算视频的右边A部分
    float right = in.texCoordinate.x / 2 + 0.5;
    float alpha = tex.sample(texSampler, float2(right, in.texCoordinate.y)).r;

    return float4(rgb, alpha);
    
}

