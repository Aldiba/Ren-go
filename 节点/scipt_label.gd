extends Script_Root
class_name Script_Label
@onready var name_label = $name

# 定义Tween的目标值
var target_scale = 1.05
var normal_scale = 1.0
var normal_color = Color(0.9, 0.9, 0.9, 0.8)
var highlight_color = Color(1, 1, 1, 0.9)

#var tween_size = create_tween()
#var tween_color= create_tween()

func _ready():
	set_pivot_offset(Vector2(size.x / 2, size.y / 2))
	
	
## 当鼠标进入时触发Tween动画
#func _on_mouse_entered():
	#var tween_size = create_tween()
	##var tween_color = create_tween()
#
	## 使用Tween渐进改变scale_factor和highlight_color
	#tween_size.tween_property(self, "scale", Vector2(1.05,1.05), 0.1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	##tween_color.tween_property(material, "shader_parameter/highlight_color", 1.1, 0.1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
#
#
## 当鼠标离开时触发Tween动画
#func _on_mouse_exited():
	#var tween_size = create_tween()
	##var tween_color = create_tween()
	#
	## 使用Tween渐进恢复scale_factor和highlight_color
	#tween_size.tween_property(self, "scale", Vector2(1.00,1.0), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	##tween_color.tween_property(material, "shader_parameter/highlight_color", 1, 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
