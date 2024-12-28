extends Panel
#@onready var transform_select = $OptionButton
@onready var transform_select = $Label
@onready var transform_value = $LineEdit
#@onready var transform_type = $OptionButton
@onready var Root_node = $"../../../../.."
var transform_key
var parameter_key
var default_value:float
func _ready() -> void:
	default_value = transform_value.value
	#pass

func _on_line_edit_value_changed(value: float) -> void:
	Root_node.transform_dic_list[transform_key]["trans"][parameter_key] = value
	default_value = value
