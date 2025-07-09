shader_type canvas_item;

uniform float lod: hint_range (0.0, 20) = 15.0;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// 边框参数
uniform vec4 border_color : source_color = vec4(1.0, 1.0, 1.0, 0.8); // 边框颜色和透明度
uniform float border_width : hint_range(0.0, 0.2) = 0.02; // 边框宽度
uniform float border_radius : hint_range(0.0, 0.5) = 0.1; // 边框圆角半径

void fragment() {
    // 计算中心距离（考虑UV坐标）
    vec2 center = vec2(0.5, 0.5);
    vec2 uv_offset = abs(UV - center) * 2.0; // 转换为0-1范围
    
    // 计算圆角效果
    float corner_dist = length(max(uv_offset - (1.0 - border_radius * 2.0), 0.0));
    float border_mask = smoothstep(border_width - 0.005, border_width + 0.005, 
                                 min(1.0 - uv_offset.x, 1.0 - uv_offset.y));
    
    // 应用圆角
    float rounded_mask = smoothstep(border_radius, border_radius - 0.01, corner_dist);
    border_mask = min(border_mask, rounded_mask);
    
    // 获取毛玻璃效果
    vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV, lod);
    
    // 混合边框和毛玻璃效果
    if (border_mask > 0.0) {
        COLOR = mix(color, border_color, border_mask * border_color.a);
    } else {
        COLOR = color;
    }
    
    // 保持原有混合模式
    COLOR.rgb = mix(color, COLOR, COLOR.a).rgb;
}