extends Script_Root
class_name Script_Scene
@onready var name_label = $name
@onready var tex = $TextureRect
@onready var scene_select = $scene_select
@onready var transform_select = $transform_Select
var scene_key:String
var transform_key:String
# 定义Tween的目标值
var target_scale = 1.05
var normal_scale = 1.0
var normal_color = Color(0.9, 0.9, 0.9, 0.8)
var highlight_color = Color(1, 1, 1, 0.9)

#var tween_size = create_tween()
#var tween_color= create_tween()

func _ready():
	set_pivot_offset(Vector2(size.x / 2, size.y / 2))

func _on_scene_select_item_selected(index: int) -> void:
	set_texture(GlobalDict.scene_dic_list[scene_select.get_item_text(index)]["tex"])

func set_texture(tex_temp):
	#TextFloating
	tex.set_texture(tex_temp)
	resize_scene_ent()
	
func resize_scene_ent():
	custom_minimum_size.y = 33+898*tex.get_texture().get_height()/tex.get_texture().get_width()
	#tex.set_size(Vector2(898,tex.get_size().y))
	tex.position.y = 32


func _on_transform_select_item_selected(index: int) -> void:
	transform_key = transform_select.get_item_text(index)
	


#func _on_texture_rect_resized() -> void:
	#if tex:
		#tex._set_size(Vector2(898,tex.size.y))
		#tex.position.y = 32
