extends Window
@onready var texture_rect = $"icon_maker_window/显示面板/TextureRect"
var icon
var current_rect
signal texture_send
var img_scale
var crop_size
var crop_position
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
func set_img(img):
	$"icon_maker_window/显示面板/TextureRect".set_texture(img)
	$"icon_maker_window/操作面板/TextureRect".set_texture(ImageTexture.new())
	$icon_maker_window.init_panel()

func update_icon(icon_temp):
	icon = icon_temp
	emit_signal("texture_send")


func _on_close_requested() -> void:
	hide()
