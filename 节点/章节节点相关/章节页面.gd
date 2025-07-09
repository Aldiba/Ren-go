extends Control
@onready var labelport = %Label_port
@onready var lineport = %Line_port
@onready var main = $"../../.."
@onready var line_tscn = preload("res://节点/章节节点相关/label_connect_line.tscn")
@onready var label_node_tscn = preload("res://节点/章节节点相关/label_node.tscn").instantiate()
@onready var label_sub_port = preload("res://节点/章节节点相关/label_sub_port.tscn").instantiate()
#@export var chapter_dic_list : Dictionary
@export var root_label:Node
@export var max_layer: int
@export var sub_port_array:Array
func _ready() -> void:
	
	pass


func init_label_nodes():
	#生成线	
	for label_node in labelport.get_children():
		var label_key = label_node.label_key
		for jump_to_label_key in main.chapter_dic_list[label_node.label_key]["jumpto"]:
			#var jump_to_node:Node
			for another_label in labelport.get_children():
				if another_label.label_key == jump_to_label_key:
					label_node.jumpto_label[another_label.label_key]=another_label
					another_label.jumpfrom_label[label_node.label_key]=label_node
					var new_line = line_tscn.instantiate()
					%Line_port.add_child(new_line)
					new_line.start_node = label_node
					new_line.end_node = another_label
					label_node.label_lines.append(new_line)
					
					new_line.when_line_create()
					new_line.when_position_changed()
					new_line.single_connect()
					new_line.update_wave_line()
					new_line.default_color = Color.from_ok_hsl(randf_range(0,1),0.765 ,0.787 ,1.0)
					break
	label_snode_sorting_init()

func label_snode_sorting_init():
	var label_layer_dic:Dictionary
	##确认根章节
	root_label_confim(label_layer_dic)
	##从根章节延伸
	shearch_child_label(root_label)
	##各章节取最大层级并找到当前最大层级
	label_layer_maxize()
	##根据最大章节依次摆放纵向容器
	sub_port_init()
	##将layer一致的label塞进容器
	label_into_port_init()

func label_into_port_init():
	for child in labelport.get_children():
		if child.is_class("Button"):
			for sub_port in sub_port_array:
				if sub_port.layer == child.label_layer:
					labelport.remove_child(child)
					sub_port.add_child(child)

func sub_port_init():
	for i in range(max_layer+1):
		var new_sub_port = label_sub_port.duplicate()
		labelport.add_child(new_sub_port)
		new_sub_port.layer=i
		sub_port_array.append(new_sub_port)

func label_layer_maxize():
	var temp_layer_max_array:Array
	for child in labelport.get_children():
		if child.is_class("Button"):
			if child.temp_layer_array:
				child.label_layer = child.temp_layer_array.max()
			temp_layer_max_array.append(child.label_layer)
	max_layer = temp_layer_max_array.max()

func root_label_confim(label_layer_dic:Dictionary):
	for label in  labelport.get_children():
		if label.jumpfrom_label.is_empty():
			root_label = label
			label.label_layer = 0
			label_layer_dic[0]=Array()
			label_layer_dic[0].append(root_label.label_key)
			return

func shearch_child_label(label):
	for child_key in label.jumpto_label.keys():
		var child = label.jumpto_label[child_key]
		child.label_layer = label.label_layer+1
		child.temp_layer_array.append(child.label_layer)
		child.label_layer = max(label.label_layer+1,child.label_layer)
		if !child.jumpto_label.is_empty():
			shearch_child_label(child)
			
			
