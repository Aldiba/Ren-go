shader_type canvas_item;

void fragment() {
    // 获取当前像素的颜色
   //COLOR = texture(TEXTURE,UV);
    
    // 计算该颜色的灰度值，使用亮度公式
    float lumi = (COLOR.r+COLOR.g+COLOR.b)/3.0;
    
    // 设置像素颜色为灰度颜色，保留原来的 alpha
    COLOR.rgb = vec3(lumi);
}
