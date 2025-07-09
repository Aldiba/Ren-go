extends Panel
@onready var pull_button = $"推拉栏按钮"
var open:bool
func _on_推拉栏按钮_pressed() -> void:
	if pull_button.button_pressed == true:
		var tween_pull_in = create_tween()
		# 使用Tween渐进恢复scale_factor和highlight_color
		tween_pull_in.tween_property(self, "position", Vector2(-280,0), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		pull_button.text = "▶"
		open = false
		
	if pull_button.button_pressed == false:
		var tween_pull_in = create_tween()
		# 使用Tween渐进恢复scale_factor和highlight_color
		tween_pull_in.tween_property(self, "position", Vector2(0,0), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		pull_button.text = "◀"
		open = true
