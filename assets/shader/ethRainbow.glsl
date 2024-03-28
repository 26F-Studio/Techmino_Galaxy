// Original by: @bytewave from Shadertoy

uniform highp float time;

vec3 hsv2rgb(in vec3 c)
{
    vec3 rgb = clamp(abs(mod(c.x * 6.0 + vec3(0.0, 4.0, 2.0), 6.0) - 3.0) - 1.0, 0.0, 1.0);
    return c.z * mix(vec3(1.0), rgb, c.y);
}

float uniformRand(vec2 p)
{
    return fract(975.121 * sin(dot(vec2(p.x, p.y), vec2(321.654, 654.987)))) * 0.5 + 0.5;
}

float noise1D(float p)
{
    float a = uniformRand(floor(vec2(p, 0.0)));
    float b = uniformRand(floor(vec2(p + 1.0, 0.0)));
    float t = mix(a, b, fract(p));
    return t;
}

vec4 effect(vec4 color, sampler2D tex, vec2 texCoord, vec2 scrCoord) {
    vec2 uv = scrCoord.xy / love_ScreenSize.xy - 0.5;
    vec2 oriuv = uv;
    uv.y *= 2.5;
    uv += sin(uv.x * 10.0 * (uv.y * 1.11) + time) * 0.15;

    oriuv = mix(oriuv, uv, 0.1);
    float m = clamp((.37 - abs(uv.y)) * 3.0, 0.0, 1.0);
    vec3 V = hsv2rgb(vec3((uv.x * 0.1) + time * 0.25, 1.0, 1.0));
    V *= m;
    V *= 1.0 - (sin(uv.y * uv.y * 30.0) * 0.26);

    return vec4(V * noise1D(oriuv.x * 50.0 + time * 5.0) * noise1D(oriuv.x * 40.0 + time), 1.0);
}
