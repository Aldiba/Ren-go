extends Button
class_name RootLabelButton
var defalut_size:Vector2
func _ready() -> void:
	defalut_size = size

func _on_mouse_entered() -> void:
	if !button_pressed:
		var tween_size = create_tween()
		tween_size.set_parallel(true)
		tween_size.tween_property(self, "size:x",1.2*defalut_size.x, 0.4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)

func _on_mouse_exited() -> void:
	if !button_pressed:
		var tween_size = create_tween()
		tween_size.set_parallel(true)
		tween_size.tween_property(self, "size:x", defalut_size.x, 0.8).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)

func _on_toggled(toggled_on: bool) -> void:
	if button_pressed:	
		var tween_size = create_tween()
		tween_size.set_parallel(true)
		tween_size.tween_property(self, "size:x", 1.2*defalut_size.x, 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	else:	
		var tween_size = create_tween()
		tween_size.set_parallel(true)
		tween_size.tween_property(self, "size:x", defalut_size.x, 0.4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)

#func _on_focus_entered() -> void:
	#var tween_size = create_tween()
	#tween_size.set_parallel(true)
	#tween_size.tween_property(self, "size:x", 1.2*defalut_size.x, 0.05).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
#
#func _on_focus_exited() -> void:
	#var tween_size = create_tween()
	#tween_size.set_parallel(true)
	#tween_size.tween_property(self, "size:x", defalut_size.x, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
