extends OptionButton
@onready var main_node = get_tree().root.get_child(3)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mouse_entered() -> void:
	if get_parent().is_class("ScrollContainer"):
		if main_node.dragging_node and main_node.dragging_node.is_class("Button"):
			if main_node.dragging_node.button_type=="TransformButton":
					var trans_name = main_node.get_name_of_transform_by_key(main_node.dragging_node.transform_key)
					var index = GlobalDict.select_matching_option(self, trans_name)
					emit_signal("item_selected")
