shader_type canvas_item;
render_mode unshaded, blend_premul_alpha;

uniform sampler2D rune_texture : source_color;
uniform float glow_power : hint_range(0, 5) = 1.0;
uniform vec4 glow_color : source_color = vec4(1.0, 0.8, 0.2, 1.0);
uniform float time_speed = 1.0;

void fragment() {
    // 基础透明度
    vec4 tex = texture(rune_texture, UV);
    COLOR.a = tex.a * 0.3; // 保持30%基础透明度

    // 边缘检测
    float edge = length(fwidth(tex.rg)) * 10.0;

    // 动态流光
    float flow = sin(TIME * time_speed + UV.x * 5.0) * 0.5 + 0.5;
    float glow = smoothstep(0.4, 0.6, flow * edge);

    // 随机闪光粒子
    float sparkle = step(0.995, fract(sin(dot(UV, vec2(12.9898,78.233))) * 43758.5453));

    // 最终混合
    COLOR.rgb = glow_color.rgb * (glow * glow_power + sparkle * 2.0);
    COLOR.a += max(glow, sparkle) * glow_color.a;
}