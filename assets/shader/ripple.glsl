uniform float xWave,yWave;
uniform float xFreq,yFreq;
uniform float xPhase,yPhase;
vec4 effect(vec4 color,sampler2D tex,vec2 texCoord,vec2 scrCoord){
    float x=texCoord.x,y=texCoord.y;
    texCoord.x+=xWave*sin(y*xFreq+xPhase);
    texCoord.y+=yWave*sin(x*yFreq+yPhase);
    return texture2D(tex,texCoord);
}
