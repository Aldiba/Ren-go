shader_type canvas_item;
render_mode blend_premul_alpha;

uniform sampler2D noise_texture;
uniform float distortion_strength = 0.1;
uniform vec4 shield_color : source_color = vec4(0.3, 0.5, 1.0, 0.5);

void fragment() {
    // 动态噪声
    vec2 uv_distort = UV * 2.0 + vec2(TIME * 0.3, TIME * 0.2);
    vec2 noise = texture(noise_texture, uv_distort).rg * 2.0 - 1.0;

    // 边缘衰减
    float edge = length(UV - 0.5) * 2.0;
    edge = smoothstep(0.8, 1.2, edge);

	// 时态变化扭曲
	float distortion_strength_use = sin(TIME)*cos(TIME)*distortion_strength;

    // 扭曲效果
    vec2 distorted_uv = UV + noise * distortion_strength_use * (1.0 - edge);
    vec4 tex = texture(TEXTURE, distorted_uv);

    // 能量波纹
    float wave = sin(length(UV - 0.5) * 10.0 - TIME * 3.0) * 0.5 + 0.5;
    float glow = pow(wave, 3.0) * (1.0 - edge);

    // 最终颜色
    COLOR = mix(tex * shield_color, shield_color, glow * 0.5);
    COLOR.a *= 1.0 - edge * 0.8;
}