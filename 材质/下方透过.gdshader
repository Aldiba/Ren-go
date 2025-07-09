shader_type canvas_item;
uniform sampler2D bg_texture : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D noise_texture;
uniform float blur_radius : hint_range(0.5, 5.0) = 2;
uniform float distortion : hint_range(0.0, 0.1) = 0.020;
uniform float edge_glow : hint_range(0.0, 3.0) = 0.15;
uniform float glass_tint : hint_range(0.0, 1.0) = 0.3;
uniform vec4 tint_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
    // 计算全局UV坐标（考虑面板在屏幕中的位置）
    vec2 screen_uv = SCREEN_UV;
    vec2 panel_uv = UV;
    
    // 应用噪声扭曲
    vec2 noise = texture(noise_texture, screen_uv * 3.0).rg * 2.0 - 1.0;
    vec2 distorted_uv = screen_uv + noise * distortion;
    
    // 优化模糊采样（分离式高斯模糊）
    vec4 blur_color = vec4(0.0);
    float weights[5] = float[](0.227027, 0.1945946, 0.1216216, 0.054054, 0.016216);
    
    // 水平模糊
    for (int i = -4; i <= 4; i++) {
        float weight = weights[abs(i)];
        vec2 offset = vec2(float(i) * TEXTURE_PIXEL_SIZE.x * blur_radius, 0.0);
        blur_color += texture(bg_texture, distorted_uv + offset) * weight;
    }
    
    // 垂直模糊
    vec4 final_blur = vec4(0.0);
    for (int j = -4; j <= 4; j++) {
        float weight = weights[abs(j)];
        vec2 offset = vec2(0.0, float(j) * TEXTURE_PIXEL_SIZE.y * blur_radius);
        final_blur += texture(bg_texture, distorted_uv + offset) * weight;
    }
    
    blur_color = (blur_color + final_blur) * 0.5;
    
    // 边缘光效（菲涅尔效应）
    float edge = 1.0 - smoothstep(0.0, 0.2, 
        min(min(panel_uv.x, 1.0 - panel_uv.x), 
            min(panel_uv.y, 1.0 - panel_uv.y)));
    
    // 添加玻璃色调
    vec4 glass_color = blur_color;
    glass_color.rgb = mix(glass_color.rgb, tint_color.rgb, glass_tint);
    
    // 混合边缘光效
    glass_color.rgb += edge * edge_glow;
    
    // 应用基础颜色和透明度
    vec4 base_color = texture(TEXTURE, panel_uv) * COLOR;
    glass_color.a = base_color.a * 0.85; // 玻璃透明度
    
    // 最终混合
    COLOR = mix(glass_color, base_color, base_color.a * 0.3);
}