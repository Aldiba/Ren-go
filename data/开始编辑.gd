extends Button


func _on_当前文件路径_text_changed(new_text: String) -> void:
	if new_text:
		disabled = false
	else:
		disabled = true
		
