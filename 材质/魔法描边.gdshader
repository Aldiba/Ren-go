// 边缘涌动着色器 (CardGlow.gdshader)
shader_type canvas_item;
render_mode unshaded;

uniform sampler2D noise_tex : source_color;
uniform vec4 glow_color : source_color = vec4(0.3, 0.6, 1.0, 1.0);
uniform float glow_intensity : hint_range(0, 5) = 1.0;
uniform float scroll_speed = 1.0;

void fragment() {
    // 边缘检测
    float edge = 0.0;
    for(float x = -1.0; x <= 1.0; x++){
        for(float y = -1.0; y <= 1.0; y++){
            edge += abs(texture(TEXTURE, UV + vec2(x, y) * 0.005).a);
        }
    }
    edge = 1.0 - smoothstep(1.0, 8.5, edge);

    // 动态噪声
    vec2 noise_uv = UV * 2.0 + vec2(TIME * scroll_speed, 0);
    float noise = texture(noise_tex, noise_uv).r;

    // 光效组合
    float glow = edge * (sin(TIME * 3.0) * 0.5 + 0.5) * noise;
    COLOR = glow_color * glow * glow_intensity;
    COLOR.a = glow;
}
