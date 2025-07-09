extends Basic_Scroll
@onready var vbox_container=$VBoxContainer
@onready var main_node = get_tree().root.get_child(3)
var dragging_button:Control = null #拖进来的按钮
var entered_node:Control = null #正在被指的节点
var dragging_node: Control = null:  # 当前被拖动的节点
	set(value):
		dragging_node = value
		main_node.dragging_node = value
var drag_preview: Control = null:  # 分身节点
	set(value):
		drag_preview = value
		main_node.drag_preview = value
var placeholder: Control = null  # 占位符节点
var original_position: int = -1  # 原始节点的位置
var dragging_start_pos : Vector2
var is_dragging :bool
var is_pressing:bool
var dragging_offset:Vector2

var creating_new_node:bool

var test_number:int
var entering:bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



# 开始拖动
func _on_node_mouse_down(node: Control) -> void:
	dragging_start_pos =get_global_mouse_position()
	dragging_offset = dragging_start_pos - node.global_position
	dragging_node = node
	original_position = vbox_container.get_children().find(node)
	is_pressing = true
	set_process(true)

# 更新拖动和占位符
func _process(delta: float) -> void:
	if is_pressing and get_global_mouse_position().distance_to(dragging_start_pos)>60:
		dragging_start()
	
	if drag_preview:
		drag_preview.global_position = get_global_mouse_position()-dragging_offset
		update_placeholder()
	accel_scroll_moving(delta)
func dragging_start():
	is_pressing = false
	is_dragging = true
	drag_preview = create_preview(dragging_node)
	main_node.canvaslayer.add_child(drag_preview)
	if drag_preview.is_class("Button"):
		drag_preview.set_disabled(true)
	#dragging_node.set_material(load("res://材质/灰度效果.tres"))
	#dragging_node.tex.set_material(load("res://材质/灰度效果.tres"))
	dragging_node.hide()
	#if dragging_node is Script_Word:
		#dragging_node.color_show.set_material(load("res://材质/灰度效果.tres"))
	set_process(true)


func on_mouse_enter_node(enter_node):
	
	if dragging_node ==null:
		entered_node = enter_node
		$"../../CanvasLayer/Label2".set_text(enter_node.get_name())
	if dragging_node is Script_Menu:
		entered_node = null
		$"../../CanvasLayer/Label2".set_text("")

func on_mouse_exited_node(enter_node):
	
	if enter_node == entered_node:
		entered_node = null

func _on_script_browse_mouse_entered() -> void:
	entering = true
	#print("in v",test_number)
	test_number+=1
	if main_node.dragging_node:
		if main_node.dragging_node.is_class("Button"):
			#print(main_node.dragging_node.button_type)
			match main_node.dragging_node.button_type:
				"CharacterButton":
					var line_part = Array()
					line_part.append("show")
					line_part.append(main_node.dragging_node.character_key)
					line_part.append("at")
					line_part.append("pos1")
					line_part.append("with")
					line_part.append("dissolve")
					var new_node = main_node.show_ent_make(line_part)
					$"../../左侧栏/节点选择器/角色/ScrollContainer".init_dragging()
					dragging_node = new_node
					dragging_offset = Vector2(425,36)
					dragging_start()

				"SceneButton":
					var line_part = Array()
					line_part.append("sence")
					line_part.append(main_node.dragging_node.scene_key)
					line_part.append("with")
					line_part.append("dissolve")
					var new_node = main_node.scene_ent_make(line_part)
					$"../../左侧栏/节点选择器/场景/ScrollContainer".init_dragging()
					dragging_node = new_node
					dragging_offset = Vector2(425,36)
					dragging_start()
					
				"EmoButton":
					var line_part = Dictionary()
					line_part["speaker"] = main_node.dragging_node.character_key
					line_part["emo"] = main_node.dragging_node.emo_key
					line_part["content"] = ""
					var new_node = main_node.chat_ent_make(line_part["speaker"],line_part)
					$"../../右侧栏/Character_Panel/立绘展示面板/差分选择面板/ScrollContainer".init_dragging()
					dragging_node = new_node
					dragging_offset = Vector2(425,36)
					dragging_start()
				#"TransformButton":
					#if entered_node:
						#var trans_name = main_node.get_name_of_transform_by_key(main_node.dragging_node.transform_key)
						#GlobalDict.select_matching_option(entered_node, trans_name)
func _input(event: InputEvent) -> void:
	mouse_moving_check(event)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():  # 鼠标按下
			drag_preview = null
			dragging_node = null
			if entered_node != null and !is_pressing:  # 确保在点击时才开始拖动
				dragging_node = entered_node
				dragging_start_pos = get_global_mouse_position()
				dragging_offset = dragging_start_pos - dragging_node.global_position
				original_position = vbox_container.get_children().find(dragging_node)
				is_pressing = true
				set_process(true)  # 开始处理更新
				
		else:
			is_pressing = false
			is_dragging = false
			entered_node = null
			if dragging_node:
				#if creating_new_node:
					#creating_new_node = false
					#vbox_container.add_child(dragging_node)
				var new_index:int
				if placeholder:
					new_index = placeholder.get_index()
				else:
					new_index = dragging_node.get_index()
				if drag_preview and !placeholder:
					var tween =drag_preview.create_tween()
					tween.tween_property(drag_preview, "global_position", dragging_node.global_position, 0.1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
				#tween结束后
					await get_tree().process_frame
					_on_dragging_completed(new_index)
					
				if drag_preview and placeholder:
					var tween =drag_preview.create_tween()
					tween.tween_property(drag_preview, "global_position", placeholder.global_position, 0.1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
				#tween结束后
					tween.connect("finished",Callable(self,"_on_dragging_completed").bind(new_index))
		# 检测鼠标右键按下

func _on_dragging_completed(new_index):
	##TODO 改索引
	vbox_container.move_child(dragging_node, new_index)
		#chapter_dic_list[current_chapeter]["content"].erase(new_node)
	for key in main_node.chapter_dic_list.keys():
		if key == dragging_node.up_label:
			move_element(main_node.chapter_dic_list[key]["content"],dragging_node,new_index)
			break
	#main_node.Chapter_dic_list
	finalize_dragging()
	# 恢复节点状态
	init_dragging()

func move_element(arr: Array, element, target_index: int) -> Array:
	var current_index = arr.find(element)
	if current_index == -1:
		print("元素不存在于数组中")
		return arr
	if current_index == target_index:
		return arr
	# 移除元素
	arr.erase(element)
	# 调整目标索引（当current_index < target_index时）
	if current_index < target_index:
		target_index -= 1
	# 插入到目标位置
	arr.insert(clamp(target_index, 0, arr.size()), element)
	return arr

func init_dragging():

	if dragging_node:
		dragging_node.show()
	if dragging_node.script_node_type == "Word":
		dragging_node.color_show.set_material(null)
	if drag_preview:
		drag_preview.get_parent().remove_child(drag_preview)
		drag_preview.queue_free()
	if placeholder:
		placeholder.get_parent().remove_child(placeholder)
		placeholder.queue_free()
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
func create_placeholder(node) -> Control:
	var rect = node.duplicate()
	rect.set_material(load("res://材质/细胞.tres"))
	return rect

# 更新占位符位置
func update_placeholder() -> void:
	if not dragging_node:
		return
	for child in vbox_container.get_children():
		if child == dragging_node:
			continue
		var rect = child.get_global_rect()
		if rect.has_point(get_global_mouse_position()):
			var child_index = vbox_container.get_children().find(child)
			if placeholder:
				vbox_container.remove_child(placeholder)
			placeholder = create_placeholder(drag_preview)
			
			#var old_positions = []
			#for node in vbox_container.get_children():
				#if node.get_index()>child_index and node.get_index()<=child_index+10 and !node.moved:
					#var tween_current = create_tween()
					#tween_current.parallel().tween_property(node,"position",node.position+Vector2(0,placeholder.get_size().y),0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
					#node.moved = true
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
