extends Node

var character_dic_list:Dictionary
var scene_dic_list:Dictionary
func find_upper_key_func(data: Dictionary,key_name: String,target_name: String) -> String:
	for key in data:
		if data[key].get(key_name) == target_name:
			return key
	return ""  # 未找到时返回空字符串

func vector_multiply(a:Vector2,b):
	a.x = a.x *b
	a.y = a.y *b
	return a
