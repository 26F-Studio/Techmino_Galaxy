extern float color1[3];
extern float color2[3];

vec4 effect(vec4 color, sampler2D tex, vec2 texCoord, vec2 scrCoord) {
    vec4 fragColor = texture2D(tex, texCoord);
    return vec4(
        mix(color1[0], color2[0], fragColor.r),
        mix(color1[1], color2[1], fragColor.g),
        mix(color1[2], color2[2], fragColor.b),
        fragColor.a
    );
}
