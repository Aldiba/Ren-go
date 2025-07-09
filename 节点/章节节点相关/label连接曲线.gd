extends Line2D

@export var start_node:Node:
	set(value):
		start_node = value
		_start_point = value.global_position+Vector2(464,125)
@export var end_node:Node:
	set(value):
		end_node = value
		_end_point = value.global_position+Vector2(0,125)

@export var amplitude: float = 10.0    # 波浪振幅
@export var frequency: float = 2.0     # 波浪频率（建议使用整数）
@export var num_points: int = 50       # 线段上的点数

var curve_new :Curve2D = Curve2D.new()
var _start_point: Vector2
var _end_point: Vector2

func _ready() -> void:
	
	single_connect()
	when_line_create()
	#_start_point = start_node.global_position+Vector2(464,125)
	#_end_point = end_node.global_position+Vector2(0,125)

func update_wave_line():
	#_start_point = start_node.global_position+Vector2(464,125)
	#_end_point = end_node.global_position+Vector2(0,125)
	clear_points()
	var direction = (_end_point - _start_point).normalized()
	var perpendicular = direction.rotated(PI/2)  # 垂直方向
	var length = _start_point.distance_to(_end_point)

	for i in range(num_points):
		var t = i / float(num_points - 1)
		var pos = _start_point.lerp(_end_point, t)
		# 计算正弦波偏移（确保起点终点偏移为0）
		var phase = frequency * t * 2.0 * PI
		var offset = amplitude * sin(phase)
		pos += perpendicular * offset
		add_point(pos)

func single_connect():
	if start_node:
		start_node.connect_signal_lines(self)
	if end_node:
		end_node.connect_signal_lines(self)

func when_line_create():
	if start_node:
		curve_new.add_point(start_node.global_position+Vector2(464,125),Vector2(0,0),Vector2(200,0))
	if end_node:
		curve_new.add_point(end_node.global_position+Vector2(0,125),Vector2(-200,0),Vector2(0,0))
	points = curve_new.get_baked_points()

func when_position_changed():
	if curve_new.get_point_count()>1:
		curve_new.set_point_position(0,start_node.global_position+Vector2(464,125))
		curve_new.set_point_position(1,end_node.global_position+Vector2(0,125))
		points = curve_new.get_baked_points()
