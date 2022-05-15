//
//  CGMetalScaleARGBAlpha.metal
//  CGMetalMac
//
//  Created by Jason on 2022/1/6.
//

#include <metal_stdlib>
using namespace metal;
#include "CGMetalHeader.h"

fragment float4
kCGMetalScaleLeftAlphaWithARGBFragmentShader(VertexOut in [[ stage_in ]],
                                         texture2d<float, access::sample> tex [[ texture(0) ]],
                                         constant float *value [[ buffer(0) ]] ) {
    
    float point = 1.0 / 3.0;
    //0-0.3 -> 0-1
    if (in.texCoordinate.x >= 0 && in.texCoordinate.x <= point) {
        if (in.texCoordinate.y >= 0 && in.texCoordinate.y <= 0.5) {
            float leftX = in.texCoordinate.x * 3;
            float leftY = in.texCoordinate.y * 2;
            float alpha = tex.sample(texSampler, float2(leftX, leftY)).a;
            return float4(alpha, alpha, alpha, 1);
        } else {
            return float4(0,0,0,1);
        }
    } else if (in.texCoordinate.x > point && in.texCoordinate.x <= 1) {
        //0.3-1 -> 0-1
        //(0.3-1)-0.3 -> (0-0.7)
        float x = in.texCoordinate.x - point; //0.3-1 -> 0-0.7
        float tcx = x * 1.5; //0-0.7 -> 0-1
        float4 rgb = tex.sample(texSampler, float2(tcx, in.texCoordinate.y));
//        if (tcx < 0) {
//            return float4(0,1,0,1);
//        }
//        if (tcx > 1) {
//            return float4(0,0,1,1);
//        }
        return rgb;
    } else {
        return float4(0,0,0,1);
    }
}

fragment float4
kCGMetalScaleRightAlphaWithARGBFragmentShader(VertexOut in [[ stage_in ]],
                                         texture2d<float, access::sample> tex [[ texture(0) ]]) {
    float point = 1.0 / 3.0 * 2;
    
    //0-0.7 -> 0-1
    if (in.texCoordinate.x >= 0 && in.texCoordinate.x <= point) {
        float x = in.texCoordinate.x * 1.5;
        float4 rgb = tex.sample(texSampler, float2(x, in.texCoordinate.y));
        return rgb;
    } else if (in.texCoordinate.x > point && in.texCoordinate.x <= 1) {
        //0.7-1 -> 0-1
        if (in.texCoordinate.y >= 0 && in.texCoordinate.y <= 0.5) {
            //0-0.3
            float leftX = (in.texCoordinate.x - point) * 3;
            float leftY = in.texCoordinate.y * 2;
            float alpha = tex.sample(texSampler, float2(leftX, leftY)).a;
            return float4(alpha, alpha, alpha, 1);
        } else {
            return float4(0,0,0,1);
        }

    }
    //0-0.3 -> 0-1
    if (in.texCoordinate.x >= 0 && in.texCoordinate.x <= point) {
        if (in.texCoordinate.y >= 0 && in.texCoordinate.y <= 0.5) {
            float leftX = in.texCoordinate.x * 3;
            float leftY = in.texCoordinate.y * 2;
            float alpha = tex.sample(texSampler, float2(leftX, leftY)).a;
            return float4(alpha, alpha, alpha, 1);
        } else {
            return float4(0,0,0,1);
        }
    } else if (in.texCoordinate.x > point && in.texCoordinate.x <= 1) {
        //0.3-1 -> 0-1
        //(0.3-1)-0.3 -> (0-0.7)
        float x = in.texCoordinate.x - point; //0.3-1 -> 0-0.7
        float tcx = x * 1.5; //0-0.7 -> 0-1
        float4 rgb = tex.sample(texSampler, float2(tcx, in.texCoordinate.y));
//        if (tcx < 0) {
//            return float4(0,1,0,1);
//        }
//        if (tcx > 1) {
//            return float4(0,0,1,1);
//        }
        return rgb;
    } else {
        return float4(0,0,0,1);
    }
}

fragment float4
kCGMetalLeftAlphaWithARGBFragmentShader(VertexOut in [[ stage_in ]],
                                         texture2d<float, access::sample> tex [[ texture(0) ]]) {
    
    if (in.texCoordinate.x >= 0 && in.texCoordinate.x <= 0.5) {
        float leftX = in.texCoordinate.x * 2;
        float leftY = in.texCoordinate.y;
        float alpha = tex.sample(texSampler, float2(leftX, leftY)).a;
        return float4(alpha, alpha, alpha, 1);
    } else if (in.texCoordinate.x > 0.5 && in.texCoordinate.x <= 1) {
        //0.5-1 -> 0-1
        //0-0.5
        float leftX = (in.texCoordinate.x - 0.5) * 2;
        float leftY = in.texCoordinate.y;
        float4 rgba = tex.sample(texSampler, float2(leftX, leftY));
        return rgba;
    } else {
        return float4(0,0,0,1);
    }
}

fragment float4
kCGMetalRightAlphaWithARGBFragmentShader(VertexOut in [[ stage_in ]],
                                         texture2d<float, access::sample> tex [[ texture(0) ]]) {
    
    if (in.texCoordinate.x >= 0 && in.texCoordinate.x <= 0.5) {
        float leftX = in.texCoordinate.x * 2;
        float leftY = in.texCoordinate.y;
        float4 rgba = tex.sample(texSampler, float2(leftX, leftY));
        return rgba;
    } else if (in.texCoordinate.x > 0.5 && in.texCoordinate.x <= 1) {
        //0.5-1 -> 0-1
        //0-0.5
        float leftX = (in.texCoordinate.x - 0.5) * 2;
        float leftY = in.texCoordinate.y;
        float a = tex.sample(texSampler, float2(leftX, leftY)).a;
        return float4(a, a, a, 1.0);
    } else {
        return float4(0,0,0,1);
    }
}

kernel void dylibKernel(texture2d<float, access::read> inTexture  [[ texture(1) ]],
                        texture2d<half, access::write> outTexture [[ texture(0) ]],
                        uint2                          gid        [[ thread_position_in_grid ]])
{
    float4 inColor = inTexture.read(gid);
    float4 color = inColor;
    outTexture.write(half4(color), gid);
}
