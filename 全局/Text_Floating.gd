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
