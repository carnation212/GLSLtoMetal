//
//  transition_colourdistance.metal
//  GLMetalVideo
//
//  Created by HeRo Gold on 7/15/19.
//  Copyright © 2019 KMHK. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void transition_colourdistance(texture2d<float, access::read> inTexture [[ texture(0) ]],
                             texture2d<float, access::read> inTexture2 [[ texture(1) ]],
                             texture2d<float, access::write> outTexture [[ texture(2) ]],
                             device const float *progress [[ buffer(0) ]],
                             uint2 gid [[ thread_position_in_grid ]])
{
    float prog = 1.0 - *progress;
    float power = 5.0;
    
    float4 fTex = inTexture.read(gid);
    float4 tTex = inTexture2.read(gid);
    
    float m = step(distance(fTex, tTex), prog);
    
    outTexture.write( mix(
                        mix(fTex, tTex, m),
                        tTex,
                        pow(prog, power)
                     ), gid);
}
