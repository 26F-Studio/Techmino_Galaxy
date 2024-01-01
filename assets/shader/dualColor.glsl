uniform float color1[3];
uniform float color2[3];

vec4 effect(vec4 color,sampler2D tex,vec2 texCoord,vec2 scrCoord){
    vec4 texcolor=texture2D(tex,texCoord);
    return vec4(
        mix(color1[0],color2[0],texcolor.r),
        mix(color1[1],color2[1],texcolor.g),
        mix(color1[2],color2[2],texcolor.b),
        texcolor.a
    );
}
