uniform vec2 wave = vec2(.01);
uniform vec2 freq = vec2(12, 16);
uniform highp vec2 phase = vec2(0, 0);

vec4 effect(vec4 color, sampler2D tex, vec2 texCoord, vec2 scrCoord) {
    texCoord += wave.yx * sin(texCoord.yx * freq.xy + phase.xy);
    return texture2D(tex, texCoord);
}
