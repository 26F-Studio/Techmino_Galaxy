// Original by: @bytewave from Shadertoy

uniform highp float time;

float hash(vec2 p)
{
    float h = dot(p, vec2(127.1, 311.7));
    return -1.0 + 2.0 * fract(sin(h) * 43758.5453123);
}

float noise(vec2 p)
{
    vec2 cell = floor(p);

    float BottomLeft = hash(cell);
    float BottomRight = hash(cell + vec2(1.0, 0.0));
    float TopLeft = hash(cell + vec2(0.0, 1.0));
    float TopRight = hash(cell + vec2(1.0, 1.0));

    vec2 posLocal = fract(p);

    vec2 u = posLocal * posLocal * (3.0 - 2.0 * posLocal);

    float BottomLine = mix(BottomLeft, BottomRight, u.x);
    float TopLine = mix(TopLeft, TopRight, u.x);

    float CellInterpolationFinal = mix(BottomLine, TopLine, u.y);

    return CellInterpolationFinal;
}

float perlinNoise(vec2 p, float iteration)
{
    float outValue = 0.0;

    for (float i = 0.0; i < iteration; i += 1.0)
    {
        float freq = pow(2.0, i);
        float Amp = 1.0 / freq;

        outValue += sin((noise(p * freq) * Amp));
    }
    return outValue;
}

vec2 Turbul(inout vec2 p, float freq, float amp)
{
    p.x += sin(time * 5.0 + p.y * freq) * amp;
    p.y += sin(time * 5.0 + p.x * freq) * amp;
    return p;
}

void rotate(inout vec2 p, float angle, vec2 rotationOrigin)
{
    p -= rotationOrigin;
    p *= mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    p += rotationOrigin;
}

vec4 fx(vec2 p)
{
    vec3 col = 0.5 + 0.5 * cos(time + p.xyx + vec3(0, 2, 4));

    float noiseVal = 1.0;
    float l = length(p * 1.0) * 3.0;

    rotate(p, l * l * l, vec2(0.0, 0.0));

    p += perlinNoise(p * 2.0, 2.0) * 0.1 * noiseVal;
    p -= perlinNoise(p * 4.0, 2.0) * 0.05 * noiseVal;
    p += perlinNoise(p * 8.0, 2.0) * 0.025 * noiseVal;
    p -= perlinNoise(p * 8.0, 2.0) * 0.0125 * noiseVal;

    Turbul(p, 20.0, 0.05);
    Turbul(p, 50.0, 0.0125);

    float c = 1.0 - max(pow(length(p * 5.0), 0.75) * 1.0, 0.0);
    c = 1.0 - abs((sin(time) * 0.5 + 0.5) - c) * 1.0;
    return vec4(c * col, 1.0);
}

vec4 effect(vec4 color, sampler2D tex, vec2 texCoord, vec2 scrCoord)
{
    vec2 uv = scrCoord / love_ScreenSize.xy - 0.5;
    uv.x *= love_ScreenSize.x / love_ScreenSize.y;
    return fx(uv) + fx(-uv);
}
