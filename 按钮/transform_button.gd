extends RootLabelButton
class_name TransformButton
@onready var tex = $ColorRect
@onready var transform_type = $OptionButton
@onready var Root_node = $"../../../../../.."
@export var transform_key : String
@export var button_type = "TransformButton"
var default_bool :bool = false
func set_type(type:String):
	if type == "general":
		transform_type.select(0)
	elif type == "position":
		transform_type.select(3)
	elif type == "scene":
		transform_type.select(1)
	elif type == "character":
		transform_type.select(2)
	#elif type == "default":
		#transform_type.select(-1)
	#elif type == "default_position":
		#transform_type.select(-1)

func _on_option_button_item_selected(index: int) -> void:
	var old_one= transform_type.get_selected_id()
	match(index):
		-1:
			transform_type.select(old_one)
		0:
			Root_node.transform_dic_list[transform_key]["type"] = "general"
		1:
			Root_node.transform_dic_list[transform_key]["type"] = "scene"
		2:
			Root_node.transform_dic_list[transform_key]["type"] = "character"
		3:
			Root_node.transform_dic_list[transform_key]["type"] = "position"
	if transform_type.get_selected_id() == 3:
		if get_parent().name != "pos_VBox":
			Root_node.init_trans_list()
	else:
		if get_parent().name != "trans_VBox":
			Root_node.init_trans_list()
