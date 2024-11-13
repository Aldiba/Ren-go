# GlobalData.gd (autoload)

extends Node
var character_options = []
signal character_options_updated

# 更新角色选项，并通知监听者
func update_character_options(new_options):
	character_options = new_options
	emit_signal("character_options_updated")
