extern float t,w,h;
extern float rkx,rky,rb,ra,rot,rox,roy;
extern float gkx,gky,gb,ga,got,gox,goy;
extern float bkx,bky,bb,ba,bot,box,boy;
extern float a;
vec4 effect(vec4 color,Image tex,vec2 tex_coords,vec2 scr_coords){
    float x=scr_coords.x/w;
    float y=scr_coords.y/h;
    return vec4(
        rkx*x+rky*y+rb+ra*sin(rot*t+rox*x+roy*y),
        gkx*x+gky*y+gb+ga*sin(got*t+gox*x+goy*y),
        bkx*x+bky*y+bb+ba*sin(bot*t+box*x+boy*y),
        a
    );
    // .8-y*.7+.2*sin(t/6.26),
    // .2+y*.5+.15*sin(t/4.),
    // .2+x*.6-.1*sin(t/2.83),
    // .4
}
