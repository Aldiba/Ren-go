extends Panel
@onready var window = $".."
# Nodes
@onready var texture_rect = $"显示面板/TextureRect"
@onready var crop_rect = $"显示面板/缩放框"
@onready var icon_show = $"操作面板/TextureRect"
@onready var confirm_button = $"操作面板/确认按钮"

# Properties
var avatar_texture  # 当前立绘图片
var tex_size : Vector2
var character

var dragging = false  # 是否在拖动裁剪框
var drag_offset = Vector2()  # 拖动的初始偏移
var img_scale
var crop_size:
	set(value):
		crop_size= value
		window.crop_size = crop_size
var crop_position:
	set(value):
		crop_position= value
		window.crop_position = crop_position

var current_rect:Rect2:
	set(value):
		current_rect= value
		window.current_rect = current_rect

func _ready():
	# 根据图片调整窗口宽度
	init_panel()
	#pass

func init_panel():
	avatar_texture = texture_rect.get_texture()
	tex_size = avatar_texture.get_size()
	var ratio = tex_size.x / tex_size.y
	img_scale = size.y/tex_size.y
	window.img_scale = img_scale
	size = Vector2(size.y * ratio, size.y)
	window.size = size+Vector2(216,0)
	
	# 初始化裁剪框
	crop_rect.position.x = img_scale* tex_size.x/ 3
	crop_rect.position.y = img_scale*0.25*abs(tex_size.y - 2*tex_size.x)
	crop_rect.size = Vector2(img_scale*tex_size.y / 6,img_scale*tex_size.y / 6)

func _process(delta: float) -> void:
	crop_size = crop_rect.size
	crop_position = crop_rect.position
	
func get_cropped_texture(region: Rect2) -> ImageTexture:
	var img = texture_rect.get_texture().get_image()
	img.blit_rect(img, region, Vector2(0, 0))
	window.current_rect = region
	img.crop(crop_rect.size.x/img_scale, crop_rect.size.x/img_scale)
	var cropped_texture = ImageTexture.new()
	cropped_texture.set_image(img)
	return cropped_texture

func _on_确认按钮_pressed() -> void:
	window.crop_size = crop_size
	window.crop_position = crop_position
	var region = Rect2(GlobalDict.vector_multiply(crop_position,1/img_scale), GlobalDict.vector_multiply(crop_size,1/img_scale))
	var cropped_texture = get_cropped_texture(region)
	#emit_signal("icon_cropped", cropped_texture)
	#queue_free()
	icon_show.set_texture(cropped_texture)
	window.update_icon(cropped_texture)
	


func _on_预览按钮_pressed() -> void:
	window.crop_size = crop_size
	window.crop_position = crop_position
	var region = Rect2(GlobalDict.vector_multiply(crop_position,1/img_scale), GlobalDict.vector_multiply(crop_size,1/img_scale))
	var cropped_texture = get_cropped_texture(region)
	#emit_signal("icon_cropped", cropped_texture)
	#queue_free()
	icon_show.set_texture(cropped_texture)
	#window.update_icon(cropped_texture)
