extends VBoxContainer

var active_button = null

func init_active_button():
	active_button = null

func _ready():
	#for button in get_children():
		#if button is Button:
			#button.connect("pressed", Callable(self,"_on_button_pressed"))
	pass
func _on_button_pressed(button: Button):
	# 清除之前激活的按钮状态
	if active_button:
		active_button.focus_mode = Control.FOCUS_NONE
		active_button.set_pressed(false)
		
	# 设置新按下的按钮为激活状态
	active_button = button
	active_button.focus_mode = Control.FOCUS_ALL
	active_button.set_pressed(true)
	
	#普通变化面板按钮失效化
	for temp_button in $"../../Transform_Panel/VBoxContainer".get_children():
		temp_button.set_pressed(false)
	# 自定义外观变化或高亮
	update_button_styles()
	
func update_button_styles():
	for button in get_children():
		if button is Button:
			if button == active_button:
				# 设置激活状态的样式
				#button.add_theme_color_override("font_color", Color(1, 0, 0))
				pass
			else:
				# 恢复非激活状态的样式
				button.add_theme_color_override("font_color", Color(1, 1, 1))
