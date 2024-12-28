shader_type canvas_item;

uniform float line_width : hint_range(1.0, 10.0) = 2.0;  // 虚线宽度
uniform float dash_length : hint_range(0.0, 20.0) = 5.0; // 虚线段长度
uniform float gap_length : hint_range(0.0, 20.0) = 5.0;  // 虚线间隔长度
uniform float rotation_speed : hint_range(0.0, 5.0) = 1.0;  // 旋转速度

void fragment() {
    // 获取片元的坐标
    vec2 uv = FRAGCOORD.xy / SCREEN_PIXEL_SIZE;

    // 计算旋转角度
    float rotation = TIME * rotation_speed;

    // 创建旋转矩阵
    mat2 rotation_matrix = mat2(cos(rotation));

    // 计算边界坐标
    vec2 center = vec2(0.5, 0.5);  // 纹理中心
    vec2 rotated_uv = rotation_matrix * (uv - center) + center;  // 旋转后的坐标

    // 获取与边缘的距离
    float edge_dist = length(rotated_uv - center);

    // 计算虚线模式（通过整除以创造虚线效果）
    float pattern = mod(edge_dist, dash_length + gap_length);

    // 如果在虚线段内显示颜色
    if (pattern < dash_length) {
        COLOR = vec4(1.0, 1.0, 1.0, 1.0); // 可以更改颜色
    } else {
        discard;  // 否则不显示
    }
}
