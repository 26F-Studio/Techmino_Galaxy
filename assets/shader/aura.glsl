uniform float phase;
uniform float alpha;
vec4 effect(vec4 color,sampler2D tex,vec2 texCoord,vec2 scrCoord){
    vec2 p=vec2(scrCoord.x/love_ScreenSize.x,scrCoord.y/love_ScreenSize.y);
    vec3 c=vec3(0.);
    c.r+=smoothstep(1.26,0.,length(vec2(0.5+cos(phase*6.*0.26)*0.4-p.x,0.5-sin(phase*3.*0.62)*0.4-p.y)));
    c.g+=smoothstep(1.26,0.,length(vec2((0.5+cos(phase*6.*0.32)*0.4)-p.x,(0.5-sin(phase*3.*0.80)*0.4)-p.y)));
    c.b+=smoothstep(1.26,0.,length(vec2((0.5-cos(phase*6.*0.49)*0.4)-p.x,(0.5+sin(phase*3.*0.18)*0.4)-p.y)));
    c.rg+=vec2(smoothstep(0.626,0.,length(vec2((0.5+cos(phase*0.96)*0.4)-p.x,(0.5-sin(phase*0.46)*0.4)-p.y))));
    c.rb+=vec2(smoothstep(0.626,0.,length(vec2((0.5+cos(phase*0.82)*0.4)-p.x,(0.5+sin(phase*0.57)*0.4)-p.y))));
    c.gb+=vec2(smoothstep(0.626,0.,length(vec2((0.5-cos(phase*0.53)*0.4)-p.x,(0.5-sin(phase*0.32)*0.4)-p.y))));

    return vec4(c/max(max(c.r,c.g),c.b),alpha);
}
