extends Panel

var is_on = false
var is_dragging = false
var drag_offset:Vector2
var way_to_mouse:Vector2
var resize_mode = ""
var start_rect = Rect2()

var in_bottom:bool
var in_right:bool
var in_top:bool
var in_left:bool
func _ready():
	#for corner in get_corner_controls():
		#corner.connect("gui_input", Callable(self, "_on_corner_resize"))
	for edge in get_edge_controls():
		edge.connect("gui_input", Callable(self, "_on_edge_resize"))
	#for edge in get_edge_controls():
		#edge.connect("gui_input", Callable(self, "_on_edge_resize").bind(edge.name))

func _process(delta: float) -> void:
	if is_dragging:
		self.position = get_global_mouse_position() - way_to_mouse

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and is_on == true:
			is_dragging = true
			way_to_mouse = event.position - position
		else:
			is_dragging = false

func _on_edge_resize(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			start_rect = Rect2(position, size)
			resize_mode = "edge"
		else:
			resize_mode = ""
	elif event is InputEventMouseMotion and resize_mode == "edge":
		# 计算水平或垂直调整的逻辑，根据需求设置方向
		var change = max_abs(event.relative.x,event.relative.y)
		#if in_right and in_bottom:
			#size.x += change  # 根据实际方向调整
			#size.y += change
		#elif in_left and in_bottom:
			#position.x -= change
			#size.x += change  # 根据实际方向调整
			#size.y += change
		#elif in_left and in_top:
			#position.y -= change
			#position.x -= change
			#size.x += change  # 根据实际方向调整
			#size.y += change
		#elif in_right and in_top:
			#position.y -= change
			#size.x += change # 根据实际方向调整
			#size.y += change
			#
		if in_right:
			size.x += change
			size.y += change
		elif in_bottom:	
			size.y += change
			size.x += change
		elif in_left:
			position.y += change
			position.x += change
			size.y -= change
			size.x -= change
		elif in_top:
			position.y += change
			position.x += change
			size.y -= change
			size.x -= change
		
func max_abs(a,b):
	if abs(a)>abs(b):
		return a
	elif abs(a)<=abs(b):
		return b
func get_edge_controls():
	return [get_node("LeftEdge"), get_node("RightEdge"), get_node("TopEdge"), get_node("BottomEdge")]

func _on_mouse_entered() -> void:
	is_on = true # Replace with function body.
func _on_mouse_exited() -> void:
	is_on = false # Replace with function body.
func get_resize_direction(edge_name):
	match edge_name:
		"LeftEdge":
			return "left"
		"RightEdge":
			return "right"
		"TopEdge":
			return "top"
		"BottomEdge":
			return "bottom"
	return ""

func _on_left_edge_mouse_entered() -> void:
	in_left = true
	in_right = false
func _on_right_edge_mouse_entered() -> void:
	in_right = true
	in_left = false
func _on_top_edge_mouse_entered() -> void:
	in_top = true
	in_bottom = false
func _on_bottom_edge_mouse_entered() -> void:
	in_bottom = true
	in_top = false
