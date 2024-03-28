uniform highp float time;
uniform float alpha = 1.0;

vec4 effect(vec4 color, sampler2D tex, vec2 texCoord, vec2 scrCoord) {
    vec2 p = vec2(scrCoord.x / love_ScreenSize.x, scrCoord.y / love_ScreenSize.y);
    vec3 fragColor = vec3(0.0);
    highp float time = time;
    fragColor.r += smoothstep(0.0, 1.26, length(vec2(0.5 + cos(time * 6.0 * 0.26) * 0.4 - p.x, 0.5 - sin(time * 3.0 * 0.62) * 0.4 - p.y)));
    fragColor.g += smoothstep(0.0, 1.26, length(vec2((0.5 + cos(time * 6.0 * 0.32) * 0.4) - p.x, (0.5 - sin(time * 3.0 * 0.80) * 0.4) - p.y)));
    fragColor.b += smoothstep(0.0, 1.26, length(vec2((0.5 - cos(time * 6.0 * 0.49) * 0.4) - p.x, (0.5 + sin(time * 3.0 * 0.18) * 0.4) - p.y)));
    fragColor.rg += vec2(smoothstep(0.0, 0.626, length(vec2((0.5 + cos(time * 0.96) * 0.4) - p.x, (0.5 - sin(time * 0.46) * 0.4) - p.y))));
    fragColor.rb += vec2(smoothstep(0.0, 0.626, length(vec2((0.5 + cos(time * 0.82) * 0.4) - p.x, (0.5 + sin(time * 0.57) * 0.4) - p.y))));
    fragColor.gb += vec2(smoothstep(0.0, 0.626, length(vec2((0.5 - cos(time * 0.53) * 0.4) - p.x, (0.5 - sin(time * 0.32) * 0.4) - p.y))));

    return vec4(fragColor / max(max(fragColor.r, fragColor.g), fragColor.b), alpha);
}
