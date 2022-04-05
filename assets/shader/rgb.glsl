uniform float phase;
uniform float rkx,rky,rb,ra,rot,rox,roy;
uniform float gkx,gky,gb,ga,got,gox,goy;
uniform float bkx,bky,bb,ba,bot,box,boy;
uniform float a;
vec4 effect(vec4 color,sampler2D tex,vec2 texCoord,vec2 scrCoord){
    float x=scrCoord.x/love_ScreenSize.x;
    float y=scrCoord.y/love_ScreenSize.y;
    return vec4(
        rkx*x+rky*y+rb+ra*sin(rot*phase+rox*x+roy*y),
        gkx*x+gky*y+gb+ga*sin(got*phase+gox*x+goy*y),
        bkx*x+bky*y+bb+ba*sin(bot*phase+box*x+boy*y),
        a
    );
    // .8-y*.7+.2*sin(t/6.26),
    // .2+y*.5+.15*sin(t/4.),
    // .2+x*.6-.1*sin(t/2.83),
    // .4
}
