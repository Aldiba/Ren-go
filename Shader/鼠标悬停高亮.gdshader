shader_type canvas_item;

uniform float highlight_color : hint_range(0, 3.0) = 1.0;  //高亮颜色

void fragment() {
    // 获取纹理颜色

   //vec4 original_color = texture(TEXTURE, UV);

    // 将颜色乘上一个可控的乘数，用于调节亮度
    COLOR.r = COLOR.r * highlight_color;
	COLOR.g = COLOR.g * highlight_color;
	COLOR.b = COLOR.b * highlight_color;
}
