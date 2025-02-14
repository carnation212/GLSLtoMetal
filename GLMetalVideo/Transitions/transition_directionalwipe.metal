//
//  transition_directionalwipe.metal
//  GLMetalVideo
//
//  Created by HeRo Gold on 7/15/19.
//  Copyright © 2019 KMHK. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void transition_directionalwipe(texture2d<float, access::read> inTexture [[ texture(0) ]],
                                   texture2d<float, access::read> inTexture2 [[ texture(1) ]],
                                   texture2d<float, access::write> outTexture [[ texture(2) ]],
                                   device const float *progress [[ buffer(0) ]],
                                   uint2 gid [[ thread_position_in_grid ]])
{
    float prog = 1.0 - *progress;
    float2 direction = float2(1.0, -1.0);
    float smoothness = 0.5;
    
    const float2 center = float2(0.5, 0.5);
    
    float2 v = normalize(direction);
    v /= abs(v.x) + abs(v.y);
    
    float2 size = float2(inTexture.get_width(), inTexture.get_height());
    
    float d = v.x * center.x + v.y * center.y;
    float2 uv = float2(gid) / size;
    float m = (1.0 - step(prog, 0.0)) * (1.0 - smoothstep(-smoothness, 0.0, v.x * uv.x + v.y * uv.y - (d - 0.5 + prog * (1. + smoothness))));
    
    outTexture.write( mix(inTexture.read(uint2(gid.x, size.y - gid.y)), inTexture2.read(uint2(gid.x, size.y - gid.y)), m), uint2(gid.x, size.y - gid.y));
}
