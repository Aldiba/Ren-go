shader_type canvas_item;

// 模糊半径（可调参数）
uniform float lod : hint_range(0.0, 10) = 3.0;
// 透明度（0为完全透明，1为不透明）
uniform float alpha : hint_range(0, 1) = 0.8;
uniform vec4 glass_color : source_color;
// 屏幕纹理（需在Viewport设置中启用）
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest_mipmap;

void fragment() {
    // 获取当前UV坐标
    vec2 uv = UV;
    vec4 color = texture (SCREEN_TEXTURE, SCREEN_UV, lod);
	
	if (lod>0.0){
		vec4 _glass_color = glass_color;
		_glass_color.a =lod;
		COLOR = mix(_glass_color, color, 0.5);
		
	}
	else{
		COLOR = color;
	}
	COLOR.a = alpha;
}