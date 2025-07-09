shader_type canvas_item;

//const float PI = 3.141592654;

vec3 hash32(vec2 p) {
    vec3 p3 = fract(vec3(p.xyx) * vec3(.1031, .1030, .0973));
    p3 += dot(p3, p3.yxz+19.19);
    return fract((p3.xxy+p3.yzz)*p3.zyx);
}

vec4 disco(vec2 uv) {
    float v = abs(cos(uv.x * PI * 2.) + cos(uv.y * PI * 2.)) * .5;
    uv.x -= .5;
    vec3 cid2 = hash32(vec2(floor(uv.x - uv.y), floor(uv.x + uv.y)));
    return vec4(cid2, v);
}

void fragment() {
    vec2 R = 1.0/SCREEN_PIXEL_SIZE; // 替换iResolution
    vec2 uv = FRAGCOORD.xy/R.xy;
    uv.x *= R.x/R.y; // 保持宽高比

    // 坐标系统调整（Godot UV原点在左上角）
    uv.y = 1.0 - uv.y;

    float t = TIME * 0.6;
    uv *= 8.0;
    uv -= vec2(t*0.5, -t*0.3);

    vec4 col = vec4(1.0);
    for(int i = 1; i <= 4; ++i) {
        float fi = float(i);
        uv /= fi*0.9;
        vec4 d = disco(uv);
        float curv = pow(d.a, 0.44-((1./fi)*0.3));
        curv = pow(curv, 0.8+(d.b * 2.0));
        col *= clamp(d * curv, 0.35, 1.0);
        uv += t*(fi+0.3);
    }

    // 后处理
    col = clamp(col, 0.0, 1.0);
    vec2 N = (FRAGCOORD.xy/R.xy) - 0.5;
    col = 1.0 - pow(1.0 - col, vec4(30.0));
    col.rgb += hash32(FRAGCOORD.xy + TIME).r*0.07;
    col *= 1.1 - smoothstep(0.4, 0.405, abs(N.y));
    col *= 1.0 - dot(N, N*1.7);
    col.a = 1.0;

    COLOR = col;
}