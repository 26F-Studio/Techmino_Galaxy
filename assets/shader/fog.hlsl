// Original by: @bytewave from Shadertoy

extern highp float time;

float rand3d(vec3 co, float seed)
{
    return sin(fract((sin(dot(co, vec3(30.233 * seed, 7.233 * seed, 20.2352 * seed)))) * 815150.5453) * 321.321);
}

float Noise3d(vec3 pos, float size, float seed)
{
    float GridX = floor(pos.x * size);
    float NextGridX = floor((pos.x + (1.0 / size)) * size);
    float GridY = floor(pos.y * size);
    float NextGridY = floor((pos.y + (1.0 / size)) * size);
    float GridZ = floor(pos.z * size);
    float NextGridZ = floor((pos.z + (1.0 / size)) * size);
    vec3 PosGrid = mod((pos), 1.0 / size) * size;

    PosGrid = smoothstep(0.0, 1.0, PosGrid);

    //FrontFace
    float CornerUpLeftFrontRandom = rand3d(vec3(GridX, GridY, GridZ), 1.0);
    float CornerUpRightFrontRandom = rand3d(vec3(NextGridX, GridY, GridZ), 1.0);
    float CornerDownLeftFrontRandom = rand3d(vec3(GridX, NextGridY, GridZ), 1.0);
    float CornerDownRightFrontRandom = rand3d(vec3(NextGridX, NextGridY, GridZ), 1.0);
    float MixUp_Front = mix(CornerUpLeftFrontRandom, CornerUpRightFrontRandom, PosGrid.x);
    float MixDown_Front = mix(CornerDownLeftFrontRandom, CornerDownRightFrontRandom, PosGrid.x);
    //BackFace
    float CornerUpLeftBackRandom = rand3d(vec3(GridX, GridY, NextGridZ), 1.0);
    float CornerUpRightBackRandom = rand3d(vec3(NextGridX, GridY, NextGridZ), 1.0);
    float CornerDownLeftBackRandom = rand3d(vec3(GridX, NextGridY, NextGridZ), 1.0);
    float CornerDownRightBackRandom = rand3d(vec3(NextGridX, NextGridY, NextGridZ), 1.0);
    float MixUp_Back = mix(CornerUpLeftBackRandom, CornerUpRightBackRandom, PosGrid.x);
    float MixDown_Back = mix(CornerDownLeftBackRandom, CornerDownRightBackRandom, PosGrid.x);
    //FrontFace
    float MixFrontFace = mix(MixUp_Front, MixDown_Front, PosGrid.y);
    //BackFace
    float MixBackFace = mix(MixUp_Back, MixDown_Back, PosGrid.y);
    //MixCube
    float MixCube = mix(MixFrontFace, MixBackFace, PosGrid.z);
    return MixCube;
}

float perlinNoise3d(vec3 pos, float size, float seed, float iteration)
{
    float r = 0.0;
    for (float i = 0.0; i < iteration; i++)
    {
        float freq = pow(2.0, i);
        r += Noise3d(pos, size * freq, seed) * (1.0 / freq);
    }
    return r;
}

vec4 effect(vec4 color, sampler2D tex, vec2 texCoord, vec2 scrCoord)
{
    vec2 uv = scrCoord / love_ScreenSize.xy - 0.5;

    vec3 pos = vec3(uv.xy, 1.0);
    pos += (perlinNoise3d(pos + time * 0.02, 5.0, 1.0, 21.0) * 0.5 + 0.5) * 0.1;

    const float seed = 1.0;
    const float size = 10.0;
    const float iteration = 21.0;

    return vec4(vec3(perlinNoise3d(pos + time * 0.02, size, seed, iteration) * 0.25 + 0.5), 1);
}
