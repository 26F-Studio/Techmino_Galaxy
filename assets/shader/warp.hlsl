extern vec4 hitWaves[8];
// [0]= float x (0~1),
// [1]= float y (0~1),
// [2]= float power 1,
// [3]= float power 2,

vec4 effect(vec4 color, sampler2D tex, vec2 texCoord, vec2 scrCoord) {
    for (int i = 0; i < 10; i++) {
        if (hitWaves[i][2] == 0.0) continue;
        texCoord.xy -= sin(distance(texCoord, hitWaves[i].xy) * hitWaves[i][2])
                * hitWaves[i][3]
                * normalize(texCoord.xy - hitWaves[i].xy);
    }
    return texture2D(tex, texCoord);
}
