extends RootLabelButton
class_name CharacterButton
@onready var tex = $Icon
@onready var color_rect = %ColorRect
var character_key : String
var character : Dictionary
@export var button_type = "CharacterButton"

func _ready() -> void:
	defalut_size = size

func change_color(color):
	#var style = StyleBoxFlat.new
	#style = theme.get("Button/styles/normal")
	#style.set_bg_color(color)
	#theme.set("Button/styles/normal",style)
	color_rect.color = color
