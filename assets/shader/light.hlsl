extern float k, b;

vec4 effect(vec4 color, sampler2D tex, vec2 texCoord, vec2 scrCoord) {
    vec4 fragColor = texture2D(tex, texCoord);
    return vec4((fragColor.rgb * k + b) * color.rgb, fragColor.a * color.a);
}
