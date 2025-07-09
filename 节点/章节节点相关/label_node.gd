# ConnectionNode.gd
@tool
extends Button

@onready var outputport = %OutputPoint
@onready var inputport = %InputPoint
@onready var imgport = %TextureRect

var is_dragging:bool
var way_to_mouse:Vector2
var mouse_in:bool
var mouse_in_line_edit:bool
var last_position:Vector2
var temp_layer_array:Array
@export var label_layer:int = 0:
	set(value):
		label_layer = value
		layer_changed.emit()
@export var title := "Node" : set = set_title
@export var label_key :String : set = set_key
@export var jumpto_label:Dictionary
@export var jumpfrom_label:Dictionary
@export var label_lines : Array


var _position: Vector2:
	set(value):
		_position = value
		position_changed.emit()

signal position_changed
signal layer_changed
#signal node_clicked

func _init() -> void:
	set_notify_local_transform(true)
	set_focus_mode(1)

func set_title(v):
	title = v
	%Name_Label.set_text(v)
func set_key(v):
	label_key = v
	%Key_Label.set_text(v)
	%Name_Label.set_text(v)
func set_img(img):
	imgport.set_texture(img)
func _notification(what):
	if what == NOTIFICATION_LOCAL_TRANSFORM_CHANGED:
		position_changed.emit()
		
	
func connect_signal_lines(line:Node):
	connect("position_changed", Callable(line, "when_position_changed"))
	line._start_point = line.start_node.global_position+Vector2(464,125)
	line._end_point = line.end_node.global_position+Vector2(0,125)

func _process(delta: float) -> void:
	if is_dragging:
		_set_position(get_global_mouse_position() - way_to_mouse)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			
			if !mouse_in_line_edit:
				%Name_Label.release_focus()
			if mouse_in:
				last_position = position
				is_dragging = true
				way_to_mouse = get_global_mouse_position() - position
				#node_clicked.emit(label_key)
				
		else:
			if is_dragging:
				var tween= create_tween()
				tween.tween_property(self,"position",last_position,0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
				is_dragging = false		



func _on_mouse_entered() -> void:
	mouse_in = true
func _on_mouse_exited() -> void:
	mouse_in = false
func _on_name_label_mouse_entered() -> void:
	mouse_in_line_edit = true
func _on_name_label_mouse_exited() -> void:
	mouse_in_line_edit = false


func _on_pressed() -> void:
	pass # Replace with function body.
