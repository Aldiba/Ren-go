// 残影着色器 (GhostEffect.gdshader)
shader_type canvas_item;
render_mode blend_premul_alpha;

uniform float fade_speed = 2.0;
uniform vec3 ghost_color = vec3(0.2, 0.5, 1.0);

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    float alpha = tex.a * (1.0 - TIME * fade_speed);

    // 添加扭曲效果
    vec2 uv_offset = vec2(sin(TIME * 5.0 + UV.y * 10.0) * 0.02, 0);
    vec4 distorted = texture(TEXTURE, UV + uv_offset);

    // 颜色混合
    COLOR.rgb = mix(distorted.rgb, ghost_color, 0.7);
    COLOR.a = alpha * smoothstep(0.0, 0.3, alpha);
}