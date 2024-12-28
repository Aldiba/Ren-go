shader_type canvas_item;

uniform float time : hint_range(0.0, 1.0);  // 动态时间，控制动画变化
uniform float glow_size : hint_range(0.0, 0.5) = 0.2;  // 环绕光环的大小

void fragment() {
    // 获取当前像素到中心的距离
    vec2 center = vec2(0.5, 0.5);  // 假设卡片的中心是(0.5, 0.5)
    vec2 uv = FRAGCOORD.xy / SCREEN_PIXEL_SIZE;  // 当前像素的UV坐标
    float dist_to_center = distance(uv, center);
    
    // 外环效果（渐变的光环效果）
    float glow = smoothstep(glow_size, glow_size * 0.8, dist_to_center);
    
    // 中心区域的透明度变化（通过时间和位置来控制）
    float transparency = smoothstep(0.0, 0.2, dist_to_center);
    
    // 卡片的原始颜色和透明度
    vec4 base_color = COLOR;
    
    // 让光环有一个动态的变化效果
    vec4 ring_color = vec4(0.8, 0.2, 1.0, 1.0) * glow;  // 紫色光环，强度随距离变化
    
    // 混合光环和卡片颜色
    vec4 final_color = mix(base_color, ring_color, glow);
    //final_color.a *= (1.0 - transparency);  // 中心区域逐渐透明
    
    COLOR = final_color;
}
