extends Control
@onready var labelport = %Label_port

@export var chapter_dic_list:Dictionary
func _ready() -> void:
	find_roots(%Label_port.get_children())

func find_roots(nodes: Array) -> Array:
	var roots = []
	for node in nodes:
		var is_root = true
		for other_node in nodes:
			if node in other_node.jumpto_label:
				is_root = false
				break
		if is_root:
			roots.append(node)
	return roots
	
