extends Panel
class_name Script_Root


func _on_mouse_entered():
	var tween_size = create_tween()
	#var tween_color = create_tween()

	# 使用Tween渐进改变scale_factor和highlight_color
	tween_size.tween_property(self, "scale", Vector2(1.02,1.02), 0.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	#tween_color.tween_property(material, "shader_parameter/highlight_color", 1.01, 0.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

# 当鼠标离开时触发Tween动画
func _on_mouse_exited():
	var tween_size = create_tween()
	#var tween_color = create_tween()
	
	# 使用Tween渐进恢复scale_factor和highlight_color
	tween_size.tween_property(self, "scale", Vector2(1.00,1.00), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	#tween_color.tween_property(material, "shader_parameter/highlight_color", 1, 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
