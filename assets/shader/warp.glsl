uniform vec4 hitWaves[10];
vec4 effect(vec4 color,sampler2D tex,vec2 texCoord,vec2 scrCoord){
    for(int i=0;i<10;i++){
        if (1/(400*hitWaves[i].z+50)-.0026<0) continue;
        float dist=
            sin(
                -distance(
                    texCoord,
                    hitWaves[i].xy
                )*(6.26-2.6*hitWaves[i].z)
            )
            *cos(hitWaves[i].z*26)*(1/(400*hitWaves[i].z+50)-.0026)
            *hitWaves[i].w;
        float angle=atan(texCoord.y-hitWaves[i].y,texCoord.x-hitWaves[i].x);
        texCoord.x+=dist*cos(angle);
        texCoord.y+=dist*sin(angle);
    }
    return texture2D(tex,texCoord);
}
