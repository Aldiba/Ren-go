extends SubViewportContainer

var label_browser_bool:bool:
	set(value):
		label_browser_bool = value
		if value == false:
			$SubViewport/CanvasLayer/Camera2D.enabled = false
		if value == true:
			$SubViewport/CanvasLayer/Camera2D.enabled = true

func _on_sub_viewport_size_changed() -> void:
	$SubViewport.set_size(size)
