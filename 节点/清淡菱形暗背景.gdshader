shader_type canvas_item;

uniform float speed : hint_range(0.0, 10.0) = 1.0; // 滚动速度
uniform vec2 direction = vec2(1.0, 0.0); // 滚动方向，1.0表示水平，0.0表示垂直
uniform vec4 color = vec4(1.0, 1.0, 1.0, 1.0); // 菱形边框的颜色
uniform vec4 back_color = vec4(1.0, 1.0, 1.0, 1.0); // 菱形边框的颜色
uniform float size = 0.1; // 每个小菱形的大小
uniform float border_thickness = 0.02; // 菱形边框的粗细
uniform vec2 aspect_ratio = vec2(1.0,2.0);

uniform float line_thickness = 0.02; // 线条的粗细
uniform float spacing = 0.1; // 线条之间的间距

void fragment() {
    // 获取纹理的长宽比
    //vec2 aspect_ratio = vec2(TEXTURE_PIXEL_SIZE.x / TEXTURE_PIXEL_SIZE.y, 1.0);

    vec2 uv = UV + TIME * speed * direction;
    //uv = fract(uv); // 使UV值在[0, 1]区间内，达到无缝滚动

    // 调整UV坐标，避免因长宽比变化而拉伸
    uv.x *= aspect_ratio.x;
    uv.y *= aspect_ratio.y;

    // 计算交叉线：通过UV坐标的斜率来绘制交叉线
    float diagonal1 = abs(uv.x - uv.y); // `/` 方向的菱形线
    float diagonal2 = abs(uv.x + uv.y - 1.0); // `\` 方向的菱形线

    // 使交叉线按固定间距平铺
    diagonal1 = fract(diagonal1 / spacing); 
    diagonal2 = fract(diagonal2 / spacing); 

    // 绘制交叉线：线条的宽度由line_thickness控制
    float line1 = smoothstep(line_thickness, 0.1, diagonal1); // `/` 方向的线
    float line2 = smoothstep(line_thickness, 0.1, diagonal2); // `\` 方向的线

    // 最终的线条效果：交叉线的叠加
    float lines = max(line1, line2);

    // 输出最终颜色：根据线条的存在来调整透明度
    COLOR =lines*back_color;
}
