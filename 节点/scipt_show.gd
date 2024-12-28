extends Script_Root
class_name Script_Shown
@onready var show_select = $Show_Select
@onready var tex = $tex
@onready var character_select = $Character_Select
@onready var position_select = $Position_Select
@onready var transform_select = $Transform_Select
#@onready var color_show = $ColorRect
@onready var emo_select = $Emo_Select
# 定义Tween的目标值
var target_scale = 1.05
var normal_scale = 1.0

var emo = ""
#@export var character : Dictionary
@export var character_key :String
var character_list = []
var stylebox = get_theme_stylebox("theme_override_styles/panel","panel")
func _ready():
	set_pivot_offset(Vector2(size.x / 2, size.y / 2))

## 当鼠标进入时触发Tween动画
#func _on_mouse_entered():
	#var tween_size = create_tween()
	##var tween_color = create_tween()
	#
	## 使用Tween渐进改变scale_factor和highlight_color
	#tween_size.tween_property(self, "scale", Vector2(1.03,1.03), 0.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	##tween_color.tween_property(material, "shader_parameter/highlight_color", 1.05, 0.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
#
## 当鼠标离开时触发Tween动画
#func _on_mouse_exited():
	##theme_type_variation
	#var tween_size = create_tween()
	##var tween_color = create_tween()
	#
	## 使用Tween渐进恢复scale_factor和highlight_color
	#tween_size.tween_property(self, "scale", Vector2(1.0,1.0), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	##tween_color.tween_property(material, "shader_parameter/highlight_color", 1, 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

func _on_emo_select_item_selected(index: int) -> void:
	emo = emo_select.get_item_text(index)
	update_img(emo)
	
func update_img(emo_temp):
	tex.set_button_icon(GlobalDict.character_dic_list[character_key]["img"][emo_temp]["icon"])

func _on_character_select_item_selected(index: int) -> void:
	var character_new = character_select.get_item_text(index)
	update_character(character_new)

func update_character(character_new):
	var Root_node = $"../../../.."
	character_key = GlobalDict.find_upper_key_func(Root_node.character_dic_list,"name",character_new)
	#character = Root_node.character_dic_list[character_key]
	#color_show.set_color(Root_node.character_dic_list[character_key]["color"])
	for emo_key in Root_node.character_dic_list[character_key]["img"].keys():
		tex.set_button_icon(Root_node.character_dic_list[character_key]["img"][emo_key]["icon"])
		break
	for emo_key in Root_node.character_dic_list[character_key]["img"]:
		emo_select.add_item(emo_key,Root_node.character_dic_list[character_key]["img"][emo_key]["id"])
