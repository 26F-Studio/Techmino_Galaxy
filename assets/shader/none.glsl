vec4 effect(vec4 color,sampler2D tex,vec2 texCoord,vec2 scrCoord){
    return texture2D(tex,texCoord);
}
