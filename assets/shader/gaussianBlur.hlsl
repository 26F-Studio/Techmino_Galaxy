// Original by: @bytewave from Shadertoy

extern float smpCount; // 10
extern float radius; // 0.026

const float MAX_ITERATIONS = 100.0;

vec4 effect(vec4 color, sampler2D tex, vec2 texCoord, vec2 scrCoord) {
    vec4 res = vec4(0.0, 0.0, 0.0, 0.0);
    float weightSum = 0.0;

    for (float x = 0.0; x < MAX_ITERATIONS; x++) {
        if (x >= smpCount) break;
        for (float y = 0.0; y < MAX_ITERATIONS; y++) {
            if (y >= smpCount) break;
            vec2 kuvCentered = vec2(x, y) / smpCount - 0.5; // uv coord within the kernel

            float bell = cos(length(kuvCentered) * 3.141592653589793) * 0.5 + 0.5;
            bell *= float(abs(dot(kuvCentered, kuvCentered)) < 1.0); //discard outside the bell curve
            vec2 targOffSet = kuvCentered * radius;

            vec4 sampledTex = texture2D(tex, texCoord + targOffSet);
            res += sampledTex * bell;
            weightSum += bell;
        }
    }
    return res / weightSum;
}
