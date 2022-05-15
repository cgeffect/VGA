//
//  CGMetalBlendScaleAlpha.metal
//  VGAMac
//
//  Created by Jason on 2022/1/2.
//

#include <metal_stdlib>
using namespace metal;
#include "CGMetalHeader.h"

fragment float4
kCGMetalBlendScaleLeftAlphaFragmentShader(VertexOut in [[ stage_in ]],
                           texture2d<float, access::sample> tex [[ texture(0) ]]
                                      ) {
    
    //x = 0-1 -> 0-0.3, y = 0-1 -> 0-0.5
    float leftX = in.texCoordinate.x / 3.0;
    float leftY = in.texCoordinate.y / 2.0;
    float alpha = tex.sample(texSampler, float2(leftX, leftY)).r;

    //0-1 -> 0.3-1
    //0.3-1.3 - (x / 3)
    float diff = 1.0 / 3.0;
    float tcx = in.texCoordinate.x + diff - (in.texCoordinate.x / 3.0);
    float3 rgb = tex.sample(texSampler, float2(tcx, in.texCoordinate.y)).rgb;

    return float4(rgb, alpha);
}

fragment float4
kCGMetalBlendScaleRightAlphaFragmentShader(VertexOut in [[ stage_in ]],
                           texture2d<float, access::sample> tex [[ texture(0) ]]
                                      ) {

    //x = 0-1 -> 0-0.7,
    float diff = 1.0 / 3.0;
    float tcx = in.texCoordinate.x - diff + ((1 - in.texCoordinate.x) / 3.0);
    float3 rgb = tex.sample(texSampler, float2(tcx, in.texCoordinate.y)).rgb;

    //0-1 -> 0.7-1
    //0.7-1.7 - (x / 3 * 2)
    float diff1 = 1.0 / 3.0 * 2;
    float leftX = in.texCoordinate.x + diff1 - (in.texCoordinate.x / 3.0 * 2.0);
    float leftY = in.texCoordinate.y / 2.0;
    float alpha = tex.sample(texSampler, float2(leftX, leftY)).r;

    return float4(rgb, alpha);
}

