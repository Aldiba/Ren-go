extends Node

var character_dic_list:Dictionary
var scene_dic_list:Dictionary
var transform_dic_list:Dictionary

@export var global_label_dictionary:Dictionary
@export var global_label_info:Dictionary

@export var global_label_array:Array
@export var label_scripts_dic:Dictionary
@export var single_script_dic:Dictionary
@export var word_script:Dictionary
@export var jump_script:Dictionary
@export var show_script:Dictionary
@export var scene_script:Dictionary
@export var menu_script:Dictionary
@export var menu_single_option:Dictionary

func script_dic_maker():
	pass

func find_upper_key_func(data: Dictionary,key_name: String,target_name: String) -> String:
	for key in data.keys():
		if data[key].get(key_name) == target_name:
			return key
	return ""  # 未找到时返回空字符串

func vector_multiply(a:Vector2,b):
	a.x = a.x *b
	a.y = a.y *b
	return a

#option按钮选择对应文本的选项
func select_matching_option(option_button: OptionButton, current_text: String):
	# 遍历 OptionButton 中的所有选项
	for i in range(option_button.get_item_count()):
		# 获取每个选项的文本
		var option_text = option_button.get_item_text(i)
		# 如果选项文本和当前文本一致，选择这个选项
		if option_text == current_text:
			option_button.select(i)
			return i
			break


	
