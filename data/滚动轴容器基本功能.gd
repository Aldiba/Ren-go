extends ScrollContainer
class_name Basic_Scroll

var is_right_clicking = false  # 是否按下右键
var last_mouse_position = Vector2.ZERO  # 上一次鼠标的位置
var release_v :float
var accel = 1.0
var ving:bool
var m_start_point:Vector2
var m_end_point:Vector2
var mouse_in_contain:bool

func _process(delta: float) -> void:
	accel_scroll_moving(delta)

func _input(event: InputEvent) -> void:
	mouse_moving_check(event)
	
func mouse_moving_check(event):
# 检测鼠标中键滚动
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT or event.button_index == MOUSE_BUTTON_MIDDLE:
			if event.is_pressed():
				if mouse_in_contain:
					is_right_clicking = true
					last_mouse_position = event.position
					ving =false
			elif event.is_released():
				is_right_clicking = false
				ving = true

# 检测鼠标移动
	if event is InputEventMouseMotion and is_right_clicking:
		var delta = event.position - last_mouse_position  # 鼠标移动的距离
		scroll_vertical -= delta.y  # 调整垂直滚动
		scroll_horizontal -= delta.x  # 调整水平滚动（如果需要）
		last_mouse_position = event.position  # 更新上一次鼠标的位置
		ving=false
	
	if event is InputEventMouseButton:
		if event.button_index==MOUSE_BUTTON_WHEEL_DOWN or event.button_index==MOUSE_BUTTON_WHEEL_UP:
			ving=false
		
func accel_scroll_moving(delta: float) -> void:
	#if mouse_in_contain:	
	if !ving:
		m_end_point = get_global_mouse_position()
		release_v = (m_end_point.y - m_start_point.y)
		m_start_point = m_end_point
	if ving:
		if release_v > 4:
			release_v -= accel
			scroll_vertical -=release_v
		elif release_v < -4:
			release_v += accel
			scroll_vertical -=release_v


func _on_mouse_entered() -> void:
	mouse_in_contain = true
	#print("in")

func _on_mouse_exited() -> void:
	mouse_in_contain = false
	#print("out")
