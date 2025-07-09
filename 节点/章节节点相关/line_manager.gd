extends GraphElement
@export var connection_line = preload("res://节点/章节节点相关/Connection_Line.tscn")

func update_connection_lines():
	for line in get_children():
		remove_child(line)
		line.queue_free()
	for label_key in GlobalDict.global_label_dictionary:
		GlobalDict.global_label_dictionary[label_key]
