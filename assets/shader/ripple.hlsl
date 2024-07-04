extern vec2 wave; // 0.01,0.01
extern vec2 freq; // 12,16
extern highp vec2 phase; // 0,0

vec4 effect(vec4 color, sampler2D tex, vec2 texCoord, vec2 scrCoord) {
    texCoord += wave.yx * sin(texCoord.yx * freq.xy + phase.xy);
    return texture2D(tex, texCoord);
}
