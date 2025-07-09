shader_type canvas_item;
render_mode unshaded, blend_add;

uniform sampler2D magic_circle_texture;
uniform float rotation_speed = 1.0;
uniform vec3 core_color = vec3(0.8, 0.4, 1.0);
uniform float time_breath_x = 0.5;
uniform float time_breath_basic = 0.5;

void fragment() {
    // 旋转UV
    vec2 uv_rotated = UV - 0.5;
    float angle = TIME * rotation_speed;
    uv_rotated = mat2(vec2(cos(angle), -sin(angle)), vec2(sin(angle), cos(angle))) * uv_rotated;
    uv_rotated += 0.5;

    // 基础纹理
    vec4 tex = texture(magic_circle_texture, uv_rotated);

    // 核心光效
    float distance_from_center = length(UV - 0.5);
    float core_glow = smoothstep(0.7, 0.3, distance_from_center);

    // 符文脉动
    float pulse = sin(TIME * 3.0) * time_breath_x + time_breath_basic;
    float rune_glow = tex.a * pulse;

    // 最终效果
    COLOR.rgb = core_color * (core_glow * 0.5 + rune_glow * 1.5);
    COLOR.a = (core_glow * 0.3 + rune_glow * 0.7);
}