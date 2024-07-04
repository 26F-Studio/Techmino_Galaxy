// Original by: @la4 from Shadertoy

extern vec2 size; // 100,100

vec4 effect(vec4 color, sampler2D tex, vec2 texCoord, vec2 scrCoord)
{
    vec2 pixelSize = 1.0 / size;
    vec2 pixelId = floor(texCoord / pixelSize);

    return (
        /* DL */ texture2D(tex, pixelId * pixelSize) +
        /*  M */ texture2D(tex, (pixelId + 0.5) * pixelSize) +
        /* UR */ texture2D(tex, (pixelId + 1.0) * pixelSize) +
        /* UL */ texture2D(tex, (pixelId + vec2(0.0, 1.0)) * pixelSize) +
        /* DR */ texture2D(tex, (pixelId + vec2(1.0, 0.0)) * pixelSize)
    ) * 0.2;
}
