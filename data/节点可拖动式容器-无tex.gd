extends ScrollContainer
@onready var main_node = $"../../../.."
@onready var vbox_container = $VBoxContainer
var dragging_node: Control = null:  # 当前被拖动的节点
	set(value):
		dragging_node = value
		main_node.dragging_node = value
var drag_preview: Control = null  # 分身节点
var placeholder: Control = null  # 占位符节点
var original_position: int = -1  # 原始节点的位置
var dragging_start_pos : Vector2
var is_dragging :bool
var is_pressing:bool
var dragging_offset:Vector2
#func init_dragging_nodes():
	#for child in vbox_container.get_children():
		#child.connect("button_")

# 开始拖动
func _on_node_mouse_down(node: Control, event: String) -> void:
	if event =="pressed":
		dragging_start_pos =get_global_mouse_position()
		dragging_offset = dragging_start_pos - node.global_position
		dragging_node = node
		original_position = vbox_container.get_children().find(node)
		is_pressing = true
		set_process(true)

# 更新拖动和占位符
func _process(delta: float) -> void:
	if is_pressing and get_global_mouse_position().distance_to(dragging_start_pos)>60:
		is_pressing = false
		is_dragging = true
		drag_preview = create_preview(dragging_node)
		get_tree().root.get_child(3).find_child("CanvasLayer").add_child(drag_preview)
		drag_preview.set_disabled(true)
		
		#var tween = create_tween()
		#tween.tween_property(drag_preview,"global_position",get_global_mouse_position(),0.1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		
		#drag_preview.global_position = get_global_mouse_position()
		dragging_node.set_material(load("res://材质/灰度效果.tres"))
		set_process(true)
	
	if is_dragging and drag_preview:
		drag_preview.global_position = get_global_mouse_position()-dragging_offset
		update_placeholder()

# 松开鼠标
func _input(event: InputEvent) -> void:
	if drag_preview and dragging_node and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_released():
			is_pressing = false
			is_dragging = false
			# 插入到占位符位置
			if placeholder:
				var new_index = placeholder.get_index()
				if drag_preview:
					var tween =drag_preview.create_tween()
					tween.tween_property(drag_preview, "global_position", placeholder.global_position, 0.1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
	#tween结束后
					tween.connect("finished",Callable(self,"_on_dragging_completed").bind(new_index))
			else:
				var new_index = dragging_node.get_index()
				if drag_preview:
					var tween =drag_preview.create_tween()
					tween.tween_property(drag_preview, "global_position", dragging_node.global_position, 0.1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
					tween.connect("finished",Callable(self,"_on_dragging_completed").bind(new_index))


func _on_dragging_completed(new_index):
	is_pressing = false
	is_pressing = false
	vbox_container.move_child(dragging_node, new_index)
	finalize_dragging()
	# 恢复节点状态
	dragging_node.set_material(null)
	if drag_preview:
		get_tree().root.get_child(3).find_child("CanvasLayer").remove_child(drag_preview)
		drag_preview.queue_free()
		drag_preview = null
	dragging_node = null
	set_process(false)
	
# 创建分身节点
func create_preview(original_node: Control) -> Control:
	var preview = original_node.duplicate()  # 克隆原始节点
	preview.pivot_offset = dragging_offset
	preview.script = null
	preview.modulate = Color(1.2, 1.2, 1.2, 0.8)  # 设置透明度
	preview.set_mouse_filter(2)
	return preview

# 创建占位符
func create_placeholder() -> Control:
	var rect = drag_preview.duplicate()
	
	#rect.color = Color(0.2, 0.6, 1.0, 0.1)  # 半透明蓝色
	#rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	#rect.custom_minimum_size = Vector2(0, 60)  # 占位符高度
	rect.set_material(load("res://材质/动态边框.tres"))
	return rect

# 更新占位符位置
func update_placeholder() -> void:
	if not dragging_node:
		return
	for child in vbox_container.get_children():
		if child == dragging_node:
			#placeholder = dragging_node
			continue
		var rect = child.get_global_rect()
		if rect.has_point(get_global_mouse_position()):
			var child_index = vbox_container.get_children().find(child)
			#if placeholder and vbox_container.get_children().find(placeholder) == child_index:
				#return
			if placeholder:
				vbox_container.remove_child(placeholder)

			placeholder = create_placeholder()
			vbox_container.add_child(placeholder)
			vbox_container.move_child(placeholder, child_index)
			return

	if placeholder and placeholder!=dragging_node:
		if placeholder==dragging_node:
			placeholder =null
		else:
			vbox_container.remove_child(placeholder)
			placeholder.queue_free()
			placeholder = null
			
# 结束拖动时清理占位符
func finalize_dragging() -> void:
	if placeholder:
		vbox_container.remove_child(placeholder)
		placeholder.queue_free()
		placeholder = null
