extends Script_Root
class_name Script_Word
@onready var word = %word
@onready var tex = %tex
@onready var name_label = %name
@onready var color_show = %ColorRect
@onready var emo_select = %Emo_Select
@onready var transform_select = %Transform_Select

# 定义Tween的目标值
var target_scale = 1.05
var normal_scale = 1.0
var normal_color = Color(0.9, 0.9, 0.9, 0.8)
var highlight_color = Color(1, 1, 1, 0.9)
@export var sound_path: String = "" 
@export var character_key : String
var selected_emo:String
var selected_transform:String
var stylebox = get_theme_stylebox("theme_override_styles/panel","panel")

func _ready():
	set_pivot_offset(Vector2(size.x / 2, size.y / 2))
	#add_theme_stylebox_override("panel", stylebox)
	#stylebox.set_local_to_scene(true)

func _on_word_resized() -> void:
	custom_minimum_size.y = word.size.y+60
	set_pivot_offset(Vector2(custom_minimum_size.x / 2, custom_minimum_size.y / 2))


# 当鼠标进入时触发Tween动画
#func _on_mouse_entered():
	#var tween_size = create_tween()
	##var tween_color = create_tween()
	##var tween_shadow = create_tween()
	##var tween_shadow_size = create_tween()
	#
	## 使用Tween渐进改变scale_factor和highlight_color
	#tween_size.tween_property(self, "scale", Vector2(1.03,1.03), 0.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	##tween_color.tween_property(material, "shader_parameter/highlight_color", 1.05, 0.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	##tween_shadow.tween_property(stylebox, "shadow_color", Color(0,0,0,0.3), 0.1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	##tween_shadow_size.tween_property(stylebox, "shadow_size", 12, 0.1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	#
## 当鼠标离开时触发Tween动画
#func _on_mouse_exited():
	##theme_type_variation
	#var tween_size = create_tween()
	##var tween_color = create_tween()
	##var tween_shadow = create_tween()
	##var tween_shadow_size = create_tween()
	#
	## 使用Tween渐进恢复scale_factor和highlight_color
	#tween_size.tween_property(self, "scale", Vector2(1.0,1.0), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	##tween_color.tween_property(material, "shader_parameter/highlight_color", 1, 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	##tween_shadow.tween_property(stylebox, "shadow_color", Color(0,0,0,0.5), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	##tween_shadow_size.tween_property(stylebox, "shadow_size", 8, 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
#

func _on_emo_select_item_selected(index: int) -> void:
	selected_emo = emo_select.get_item_text(index)
	update_img(selected_emo)
	
func update_img(emo_temp):
	tex.set_button_icon(GlobalDict.character_dic_list[character_key]["img"][emo_temp]["icon"])
	


func _on_transform_select_item_selected(index: int) -> void:
	selected_transform = transform_select.get_item_text(index)

func _on_添加对应音_pressed() -> void:
	%"Audio路径选择窗口".show()


func _on_audio路径选择窗口_file_selected(path: String) -> void:
	%"Audio路径选择窗口".hide()
	sound_path = path
