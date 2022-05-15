#include "CGMetalHeader.h"
#include <simd/simd.h>

vertex VertexOut
CGMetalVertexShader(
                      uint vertexID [[ vertex_id ]],
                      constant float4 *position [[ buffer(0) ]],
                      constant float2 *texCoord [[ buffer(1) ]]
                      ) {
    VertexOut out;
    out.position = position[vertexID];
    out.texCoordinate = float2(texCoord[vertexID].x, texCoord[vertexID].y) ;
    return out;
}

fragment float4
CGMetalFragmentShader(
                        VertexOut in [[ stage_in ]],
                        texture2d<float, access::sample> tex [[ texture(0) ]]
                        ) {
    float4 color = tex.sample(texSampler, in.texCoordinate);
    return color;
}

//外界设置采样器
fragment float4
CGMetalFragmentShader1(VertexOut in [[ stage_in ]],
                       texture2d<float, access::sample> tex [[ texture(0) ]],
                       sampler sampler2D [[ sampler(0) ]]) {
    float4 color = tex.sample(sampler2D, in.texCoordinate);
    return color;
}

fragment float4
kCGMetalLeftAlphaFragmentShader(VertexOut in [[ stage_in ]],
                           texture2d<float, access::sample> tex [[ texture(0) ]]) {

    //计算视频的左边A值
    float left = in.texCoordinate.x / 2;
    float alpha = tex.sample(texSampler, float2(left, in.texCoordinate.y)).r;

    //计算视频的右边RGB值
    float tcx = in.texCoordinate.x / 2 + 0.5;
    float3 rgb = tex.sample(texSampler, float2(tcx, in.texCoordinate.y)).rgb;
    
    return float4(rgb, alpha);
    
}

fragment float4
kCGMetalRightAlphaFragmentShader(VertexOut in [[ stage_in ]],
                           texture2d<float, access::sample> tex [[ texture(0) ]]) {
    //计算视频的左边RGB部分
    float left = in.texCoordinate.x / 2;
    float3 rgb = tex.sample(texSampler, float2(left, in.texCoordinate.y)).rgb;
    
    //计算视频的右边A部分
    float right = in.texCoordinate.x / 2 + 0.5;
    float alpha = tex.sample(texSampler, float2(right, in.texCoordinate.y)).r;

    return float4(rgb, alpha);
    
}

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

fragment float4
kCGMetalScaleLeftAlphaFragmentShader(VertexOut in [[ stage_in ]],
                           texture2d<float, access::sample> tex [[ texture(0) ]],
                           constant float *value [[ buffer(0) ]] ) {
    
    //0-0.25 -> 0-0.5
    if (in.texCoordinate.x >= 0 && in.texCoordinate.x <= 0.25) {
        if (in.texCoordinate.y >= 0 && in.texCoordinate.y <= 0.5) {
            float leftX = in.texCoordinate.x * 2;
            float leftY = in.texCoordinate.y * 2;
            float4 alpha = tex.sample(texSampler, float2(leftX, leftY));
            return alpha;
        } else {
            return float4(0,1,0,1);
        }
    } else if (in.texCoordinate.x > 0.25 && in.texCoordinate.x <= 0.75) {
        //0.25-0.75 -> 0.5-1
        float tcx = in.texCoordinate.x + 0.25;
        float4 rgb = tex.sample(texSampler, float2(tcx, in.texCoordinate.y));
        return rgb;
    } else {
        return float4(1,0,0,1);
    }
}


