extends Script_Root
class_name Script_Menu
@onready var text = $describe
@onready var option_select = $OptionButton
@onready var option_text = $option_text
@onready var vbox_container = $ScrollContainer/VBoxContainer
@onready var scroll_container = $ScrollContainer
@export var menu_option_node_dic:Dictionary
var current_option_index:int
var current_option_text:String
var selected_transform:String
var stylebox = get_theme_stylebox("theme_override_styles/panel","panel")

func _ready():
	set_pivot_offset(Vector2(size.x / 2, size.y / 2))

func init_node():
	for child in vbox_container.get_children():
		vbox_container.remove_child(child)
	for option_node in menu_option_node_dic[option_select.get_item_text(current_option_index)]:
		vbox_container.add_child(option_node)

func _on_option_button_item_selected(index: int) -> void:
	current_option_index = index
	current_option_text = option_select.get_item_text(index)
	option_text.set_text(option_select.get_item_text(index))
	init_node()
	
func _on_option_text_text_submitted(new_text: String) -> void:
	option_select.set_item_text(current_option_index,new_text)
func _on_button_pressed() -> void:
	if option_text.text!="":
		option_select.add_item(option_text.text)
		menu_option_node_dic[option_text.text] = Array()
		
	
func select_option_by_text(current_text: String):
	# 遍历 OptionButton 中的所有选项
	for i in range(option_select.get_item_count()):
		# 获取当前选项的文本
		var option_text = option_select.get_item_text(i)
		
		# 如果选项文本与 current_text 相匹配，选择这个选项
		if option_text == current_text:
			option_select.select(i)  # 选择匹配的选项
			current_option_index = i
			break  # 找到后就退出循环
