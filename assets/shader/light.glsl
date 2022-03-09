extern float k,b;
vec4 effect(vec4 color,Image tex,vec2 tex_coords,vec2 scr_coords){
    vec4 texcolor=Texel(tex,tex_coords);
    return vec4(
        (texcolor.r*k+b)*color.r,
        (texcolor.g*k+b)*color.g,
        (texcolor.b*k+b)*color.b,
        texcolor.a*color.a
    );
}
