@tool
extends OptionButton
@export var init_transform_dic:Dictionary
@export var button:bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if button==true:
		button = false
		init_selecter()
func init_selecter():
	clear()
	for key in init_transform_dic:
		print(init_transform_dic[key][0])
		add_item(init_transform_dic[key][0])
