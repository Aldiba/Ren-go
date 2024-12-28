@tool
extends TabContainer

func _on_tab_selected(tab: int) -> void:
	if tab ==0:
		$"../../右侧栏/Character_Panel".show()
		$"../../右侧栏/Scene_Panel".hide()
		$"../../右侧栏/Transform_Panel".hide()
	if tab ==1:
		$"../../右侧栏/Character_Panel".hide()
		$"../../右侧栏/Scene_Panel".show()
		$"../../右侧栏/Transform_Panel".hide()
	if tab ==2:
		$"../../右侧栏/Character_Panel".hide()
		$"../../右侧栏/Scene_Panel".hide()
		$"../../右侧栏/Transform_Panel".show()
