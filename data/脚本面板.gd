extends Control
@onready var pull_button_up = $"脚本推拉栏按钮上"
@onready var vboxcontainer = $ScrollContainer/VBoxContainer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_脚本推拉栏按钮上_pressed() -> void:
	var tween_pull_in = create_tween()
	# 使用Tween渐进恢复scale_factor和highlight_color
	tween_pull_in.tween_property(self, "position", Vector2(position.x,-1*size.y), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	camera_on()
	$"..".all_ui_close()


func _on_脚本推拉栏按钮下_pressed() -> void:
	var tween_pull_in = create_tween()
	# 使用Tween渐进恢复scale_factor和highlight_color
	tween_pull_in.tween_property(self, "position", Vector2(position.x,0), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween_pull_in.tween_callback(camera_off) 
	$"..".all_ui_open()
	
func camera_on():
	$"../Label_Browse".label_browser_bool = true

func camera_off():
	$"../Label_Browse".label_browser_bool = false

func update_nodes_in_label():
	for child in vboxcontainer.get_children():
		vboxcontainer.remove_child(child)
		
