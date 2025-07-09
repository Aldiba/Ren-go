shader_type canvas_item; // 用于 2D UI 元素
uniform sampler2D screen_texture; // 绑定 Viewport 的屏幕纹理
uniform sampler2D noise_texture;  // 用于折射扭曲的噪声图
uniform float blur_radius = 2.0;  // 模糊强度
uniform float distortion = 0.02;  // 折射扭曲强度
uniform float edge_brightness = 1.5; // 边缘高光强度

void fragment() {
    // 1. 获取当前 UV 坐标
    vec2 uv = UV;
    
    // 2. 折射扭曲：用噪声扰动 UV
    vec2 noise = texture(noise_texture, uv * 5.0).rg * 2.0 - 1.0;
    vec2 distorted_uv = uv + noise * distortion;
    
    // 3. 高斯模糊：对周围像素采样混合
    vec4 blur_color = vec4(0.0);
    for (int i = -2; i <= 2; i++) {
        for (int j = -2; j <= 2; j++) {
            vec2 offset = vec2(float(i), float(j)) * TEXTURE_PIXEL_SIZE * blur_radius;
            blur_color += texture(screen_texture, distorted_uv + offset);
        }
    }
    blur_color /= 25.0; // 25 次采样平均值
    
    // 4. 边缘高光（菲涅尔效应）
    float fresnel = 1.0 - dot(vec2(0.5, 0.5), uv - 0.5);
    vec4 highlight = vec4(1.0) * fresnel * edge_brightness;
    
    // 5. 混合模糊背景与高光
    vec4 glass_color = blur_color + highlight;
    glass_color.a = 0.8; // 整体透明度
    
    // 6. 叠加 UI 前景色（可选）
    vec4 ui_color = texture(TEXTURE, uv);
    COLOR = mix(glass_color, ui_color, ui_color.a); // 按前景透明度混合
}