extends Script_Root
class_name Script_Jump
@onready var chapter_selecter = %Chapter_Selecter

func _ready():
	set_pivot_offset(Vector2(size.x / 2, size.y / 2))
	
func select_option_by_text(current_text: String):
	# 遍历 OptionButton 中的所有选项
	for i in range(chapter_selecter.get_item_count()):
		# 获取当前选项的文本
		var option_text = chapter_selecter.get_item_text(i)
		
		# 如果选项文本与 current_text 相匹配，选择这个选项
		if option_text == current_text:
			chapter_selecter.select(i)  # 选择匹配的选项
			#return current_text
			break  # 找到后就退出循环
