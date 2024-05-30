// Original by: @bytewave from Shadertoy

#define BORDER_LINE;
// #define BORDER_ROUND;

extern float tileSize; // 0.01

const float smpCount = 4.0;
const float borderSize = 0.002;

vec4 effect(vec4 color, sampler2D tex, vec2 texCoord, vec2 scrCoord)
{
    vec2 tileNumber = floor(texCoord / tileSize);

    vec4 fragColor = vec4(0.0);
    for (float i = 0.0; i < smpCount * smpCount; ++i)
    {
        float x = (mod(i, smpCount) + 0.5) / smpCount;
        float y = (floor(i / smpCount) + 0.5) / smpCount;
        fragColor += texture2D(tex, tileSize * (tileNumber + vec2(x, y)));
    }

    fragColor = fragColor / vec4(smpCount * smpCount);

    #if defined(BORDER_LINE) || defined(BORDER_ROUND)
        vec2 pixelPos = mod(texCoord - tileNumber * tileSize + borderSize * 0.5, tileSize);

        #if defined(BORDER_LINE)
            // Line Border
            float isBorder = step(min(pixelPos.x, pixelPos.y), borderSize);
        #else
            // Corner
            float isBorder = step(pixelPos.x, borderSize) * step(pixelPos.y, borderSize);
        #endif
        return fragColor * mix(vec4(1.0), fragColor, isBorder);
    #endif

    return fragColor;
}
