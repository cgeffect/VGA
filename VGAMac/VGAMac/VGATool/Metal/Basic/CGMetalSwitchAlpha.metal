//
//  CGMetalSwitchAlpha.metal
//  VGAMac
//
//  Created by Jason on 2022/1/12.
//

#include <metal_stdlib>
using namespace metal;
#include "CGMetalHeader.h"

fragment float4
kCGMetalLeftToRightAlphaFragmentShader(VertexOut in [[ stage_in ]],
                           texture2d<float, access::sample> tex [[ texture(0) ]]
                            ) {
    
    if (in.texCoordinate.x >= 0 && in.texCoordinate.x <= 0.5) {
        float left = (in.texCoordinate.x + 0.5);
        float4 rgba = tex.sample(texSampler, float2(left, in.texCoordinate.y)).rgba;
        return rgba;
    } else {
        float tcx = (in.texCoordinate.x - 0.5);
        float4 rgba = tex.sample(texSampler, float2(tcx, in.texCoordinate.y));
        return float4(rgba.r, rgba.r, rgba.r, rgba.a);
    }
}

fragment float4
kCGMetalRightToLeftAlphaFragmentShader(VertexOut in [[ stage_in ]],
                           texture2d<float, access::sample> tex [[ texture(0) ]]
                             ) {
    if (in.texCoordinate.x >= 0 && in.texCoordinate.x <= 0.5) {
        float tcx = (in.texCoordinate.x + 0.5);
        float4 rgba = tex.sample(texSampler, float2(tcx, in.texCoordinate.y));
        return float4(rgba.r, rgba.r, rgba.r, rgba.a);
    } else {
        float left = (in.texCoordinate.x - 0.5);
        float4 rgba = tex.sample(texSampler, float2(left, in.texCoordinate.y)).rgba;
        return rgba;

    }
    
}
