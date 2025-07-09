extends Path2D
@export var start_node:Node
@export var end_node:Node
var self_curve = get_curve()
func _ready() -> void:
	pass
func update_line()->void:
	var curve_new =Curve2D.new()
	curve_new.set_point_count(2)
	curve_new.add_point(start_node.get_position(), Vector2(0, -200), Vector2(0,200), 0)
	curve_new.add_point(end_node.get_position(), Vector2(0, -200), Vector2(0,200), 1)
	set_curve(curve_new)
func _process(delta: float) -> void:
	update_line()
