uniform vec4 hitWaves[10];
// [0]= float x (0~1),
// [1]= float y (0~1),
// [2]= float time (0~inf),
// [3]= float power (0~inf),

vec4 effect(vec4 color,sampler2D tex,vec2 texCoord,vec2 scrCoord){
    for(int i=0;i<10;i++){
        // Skip if this wave is finished early
        float timeK=1/(400*hitWaves[i][2]+50)-.0026;
        if (timeK<0) continue;

        float angle=atan(texCoord.y-hitWaves[i].y,texCoord.x-hitWaves[i].x);

        float dist=
            -sin(
                distance(texCoord,hitWaves[i].xy)
                *(6.26-2.6*hitWaves[i][2])
            )
            *cos(hitWaves[i][2]*26)
            *hitWaves[i][3]
            *timeK;

        texCoord.x+=dist*cos(angle);
        texCoord.y+=dist*sin(angle);
    }
    return texture2D(tex,texCoord);
}
