extends Sprite2D

func _process(delta: float) -> void:
	set("shader_parameter/iMouse",get_global_mouse_position())
