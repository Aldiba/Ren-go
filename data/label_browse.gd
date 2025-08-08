extends SubViewportContainer

var label_browser_bool:bool = false:
	set(value):
		label_browser_bool = value
		if value == false:
			$SubViewport/CanvasLayer/Camera2D.move_enabled = false
		if value == true:
			$SubViewport/CanvasLayer/Camera2D.move_enabled = true

func _on_sub_viewport_size_changed() -> void:
	$SubViewport.set_size(size)
