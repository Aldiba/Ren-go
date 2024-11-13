extends Button
@onready var tex = $Icon
var character_key : String
var character : Dictionary
var defalut_size:Vector2

func _ready() -> void:
	defalut_size = size

func change_color(color):
	var style = StyleBoxFlat.new
	style = theme.get("Button/styles/normal")
	style.set_bg_color(TextFloating.adjust_color(color))
	theme.set("Button/styles/normal",style)


func _on_mouse_entered() -> void:
	if !button_pressed:
		var tween_size = create_tween()
		tween_size.set_parallel(true)
		tween_size.tween_property(self, "size:x",1.2*defalut_size.x, 0.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

func _on_mouse_exited() -> void:
	if !button_pressed:
		var tween_size = create_tween()
		tween_size.set_parallel(true)
		tween_size.tween_property(self, "size:x", defalut_size.x, 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

func _on_toggled(toggled_on: bool) -> void:
	if button_pressed:	
		var tween_size = create_tween()
		tween_size.set_parallel(true)
		tween_size.tween_property(self, "size:x", 1.2*defalut_size.x, 0.05).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	else:	
		var tween_size = create_tween()
		tween_size.set_parallel(true)
		tween_size.tween_property(self, "size:x", defalut_size.x, 0.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	#pass

#func _on_focus_entered() -> void:
	#var tween_size = create_tween()
	#tween_size.set_parallel(true)
	#tween_size.tween_property(self, "size:x", 1.2*defalut_size.x, 0.05).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
#
#
#func _on_focus_exited() -> void:
	#var tween_size = create_tween()
	#tween_size.set_parallel(true)
	#tween_size.tween_property(self, "size:x", defalut_size.x, 0.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
