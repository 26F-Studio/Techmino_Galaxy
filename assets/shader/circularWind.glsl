// Original by: @bytewave from Shadertoy

uniform highp float time;

float rand2d(vec2 co, float seed)
{
    return fract(sin(dot(co.xy, vec2(seed, 78.233))) * 43758.5453);
}

vec4 effect(vec4 color, sampler2D tex, vec2 texCoord, vec2 scrCoord)
{
    vec2 uv = scrCoord.xy / love_ScreenSize.xy;
    vec2 uv2 = uv;

    uv += vec2(1.0 + (sin(time * 0.2) * 0.5), 1.0); // Pan uv
    uv *= 1.27; // Zoom uv

    // BackGround
    vec3 BackGround = vec3(0.0, 0.0, 0.0); // BackGround out
    vec2 pos = vec2(0.0, 0.0); // Warping Circle position
    vec2 premod = vec2(0.0, 0.0); // Not Warping Circle position
    float space = 1.0 / 5.0; // Cicles Space

    for (int i = 0; i < 5; i++)
    {
        for (int j = 0; j < 5; j++)
        {
            float fi = float(i); // float iterator
            pos = vec2(fi * 3.0 * space, float(j) * space); // Circle on a grid
            pos += sin(rand2d(pos * fi, 55.0) * (time * 0.01) * 11.6) + 1.0; // Displacement
            float value = clamp(tan(1.7 - length(pos - uv) * 3.0), 0.0, 1.0) * 0.0424; // Circle tan value
            vec3 Color = vec3(pos.x, pos.y, 1.0 - pos.y); // position to color
            BackGround += value * Color; // output color
        }
    }

    // Lines
    vec3 l = vec3(0.0, 0.0, 0.0);
    float fi = 0.0;
    float Width = 0.04;
    float WidthVariation = 0.4;
    float Intensity = 55.0;
    float Contrast = 1.5;
    float Height = 1.75;
    float Speed = 0.15;
    float SpeedVariation = 1.01;

    for (int i = 0; i < 5; i++)
    {
        fi = float(i);

        l += pow(max(Width * ((fi + 1.0) * WidthVariation) - abs(uv.y - Height + (sin(uv.x + (time * Speed) * (fi * SpeedVariation)) * (0.1 * fi))), 0.0), Contrast) * Intensity;
    }

    // Vignet
    float vignet = pow(1.0 - length(uv2 - 0.5), 1.5);

    // Composition
    return vec4(BackGround * vignet + (l * BackGround * 0.3) + (l * 0.5), 1.0);
}
