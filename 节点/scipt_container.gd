extends VBoxContainer

# 当需要对子节点进行排序时触发
#func _ready():
	## 将sort_children信号连接到自定义函数
	#connect("sort_children", _on_sort_children)
	#queue_sort()  # 请求排序
#
## 自定义子节点的排列方式
#func _on_sort_children():
	#var y_offset = 0
	#
	#for child in get_children():
		#if child is Control:
			#var height = child.custom_minimum_size.y  # 获取子控件的最小高度
			#var rect = Rect2(Vector2(0, y_offset), Vector2(size.x, height))
			#
			#fit_child_in_rect(child, rect)  # 设置子控件的位置和大小
			#
			## 根据高度增加行间距，间距为高度的10%
			#y_offset += height + height * 0.1
#
#
#func fit_child_in_rect_func(child):
	#var y_offset = 0
	#if child is Control:
		#print("change")
		#var height = child.size.y  # 获取子控件的最小高度
		#var rect = Rect2(Vector2(0, y_offset), Vector2(size.x, height))
		#fit_child_in_rect(child,rect)
		## 根据高度增加行间距，间距为高度的10%
		#y_offset += height + height * 0.1
