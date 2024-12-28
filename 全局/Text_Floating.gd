extends Node


func display_text(value:String,font_size:int,position:Vector2,color:Color=Color.WHITE):

	var number = Label.new()

	number.global_position = position
	number.z_index = 5
	number.label_settings = LabelSettings.new()
	number.text = value
	number.label_settings.font_color = color
	number.label_settings.font_size = font_size + randi_range(-2,2)
	number.label_settings.outline_color = Color.BLACK
	number.label_settings.outline_size = 3
	
	call_deferred("add_child",number)

	await number.resized
	number.pivot_offset = Vector2(number.size / 2)
	
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	var tween_outline_color = get_tree().create_tween()
	tween_outline_color.set_parallel(true)
	var tween_color = get_tree().create_tween()
	tween_color.set_parallel(true)
	
	tween.tween_property(number,"position:y",number.position.y - 200,2).set_ease(Tween.EASE_OUT)
	tween_outline_color.tween_property(number.label_settings,"outline_color",Color(0,0,0,0),2).set_ease(Tween.EASE_OUT)
	tween_color.tween_property(number.label_settings,"font_color",Color(0,0,0,0),2).set_ease(Tween.EASE_OUT)
	
	await tween.finished
	number.queue_free()

func adjust_color(color: Color):
	## 获取颜色的 HSV 值
	#var h = color.h
	#var s = color.s
	#var v = color.v
#
	## 自定义梯度调整参数，可以根据需求调整这些值
	#var max_saturation = 0.65  # 最大允许的饱和度
	#var max_value = 0.7     # 最大允许的亮度
#
	## 逐渐调整饱和度和亮度，确保不超过设定的最大值
	#s = lerp(s, max_saturation, s / 1.0) if s > max_saturation else s
	#v = lerp(v, max_value, v / 1.0) if v > max_value else v
#
	## 返回调整后的颜色
	#return Color.from_hsv(h, s, v, color.a)
	pass
