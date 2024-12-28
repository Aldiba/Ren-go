extends Control
#子场景

# UI 
@onready var warning_window = $"警告出错弹窗"
#路径
@onready var path_input = $"左侧栏/文件选择面板/当前文件路径"
@onready var import_button = $"左侧栏/文件选择面板/导入按钮"
@onready var save_button = $"左侧栏/文件选择面板/保存按钮"
@onready var save_as_button = $"左侧栏/文件选择面板/另存为按钮"
@onready var file_dialog = $"左侧栏/文件选择面板/路径选择窗口"
@onready var path_change_confim = $"左侧栏/文件选择面板/路径修改确认窗口"
@onready var save_confim = $"左侧栏/文件选择面板/保存确认窗口"

##################左侧面板#TODO
#角色列表
@onready var character_list = $"左侧栏/节点选择器/角色/ScrollContainer/VBoxContainer"
@onready var scene_list = $"左侧栏/节点选择器/场景/ScrollContainer/VBoxContainer"
@onready var transform_list = $"左侧栏/节点选择器/变换/Transform_Panel/VBoxContainer"
@onready var position_list = $"左侧栏/节点选择器/变换/Position_Panel/VBoxContainer"
@onready var craft_list = $"左侧栏/节点选择器/变换"

@onready var character_newone_window=$"左侧栏/节点选择器/角色/角色添加按钮/新建角色窗口"
#@onready var warning_key_already_have_window = $"左侧栏/节点选择器/角色/角色添加按钮/警告键值重复窗口"
@onready var scene_newone_window=$"左侧栏/节点选择器/场景/场景添加按钮/新建场景窗口"
@onready var transform_newone_window=$"左侧栏/节点选择器/变换/变换添加按钮/新建变换输入窗口"
###################
#对话显示
@onready var script_browse = $Script_Browse/ScrollContainer/VBoxContainer

#详情面板
@onready var character_details = $"右侧栏"
@onready var character_details_key = $"右侧栏/Character_Panel/Message_Panel/键值/键值Line2D"
@onready var character_details_name = $"右侧栏/Character_Panel/Message_Panel/角色名/角色名Line2D"
@onready var character_details_color = $"右侧栏/Character_Panel/Message_Panel/颜色"
@onready var character_details_color_rect = $"右侧栏/Character_Panel/Message_Panel/颜色/拾色器"

#@onready var key_change_confim= $"右侧栏/Character_Panel/Message_Panel/键值/键值改变确认窗口"
@onready var name_change_confim=$"右侧栏/Character_Panel/Message_Panel/角色名/角色名改变确认窗口"
@onready var color_change_confim=$"右侧栏/Character_Panel/Message_Panel/颜色/颜色改变确认窗口"
#立绘
@export var null_img_dic:Dictionary
@onready var emo_label = $"右侧栏/Character_Panel/立绘展示面板/差分选择面板/Emo_Label"
@onready var emo_browse = $"右侧栏/Character_Panel/立绘展示面板/差分选择面板/ScrollContainer/VBoxContainer"
@onready var error_emo_add_text_window = $"右侧栏/Character_Panel/立绘展示面板/差分选择面板/差分添加按钮/Error_emo_add_window"
@onready var emo_name_editer_window = $"右侧栏/Character_Panel/立绘展示面板/差分选择面板/差分添加按钮/差分名称输入窗口"

@onready var character_image = $"右侧栏/Character_Panel/立绘展示面板/Image_Panel/Tex"
@onready var icon_crop_button = $"右侧栏/Character_Panel/立绘展示面板/头像裁剪按钮"
@onready var icon_crop_window = $"右侧栏/Character_Panel/立绘展示面板/头像裁剪按钮/icon_maker"
@onready var image_select_window = $"右侧栏/Character_Panel/立绘展示面板/选择图片按钮/图片路径选择窗口"
@onready var choose_apply_all_window = $"右侧栏/Character_Panel/立绘展示面板/头像裁剪按钮/是否应用于该角色所有立绘"
#场景面板
@onready var scene_key_label =$"右侧栏/Scene_Panel/键值/键值Line2D"
@onready var scene_name_edit =$"右侧栏/Scene_Panel/场景名/场景名Line2D"
@onready var scene_tex_show =$"右侧栏/Scene_Panel/Image_Panel/Tex"

@onready var newscene_select_window = $"右侧栏/Scene_Panel/选择场景图片按钮/场景图片路径选择窗口"
#变换面板
@export var init_transform_dic:Dictionary
@onready var trans_key_label = $"右侧栏/Transform_Panel/键值/键值Line2D"
@onready var trans_name_edit = $"右侧栏/Transform_Panel/变换名/变换名Line2D"
@onready var trans_detail_list = $"右侧栏/Transform_Panel/Transform_Detail_Panel/VBoxContainer"

##面板显示用
@onready var left_character_panel = $"右侧栏/Character_Panel"
@onready var left_scene_panel = $"右侧栏/Scene_Panel"

##额外渲染界面
@onready var canvaslayer = $CanvasLayer
# 参数
@export var current_file_path = ""


##信息存储相关
#变换信息
# 全局变量，用于存储所有 transform 定义
var transform_dic_list :Dictionary:
	set(value):
		transform_dic_list = value
		GlobalDict.transform_dic_list = transform_dic_list
var current_transform = {}
var current_transform_key = ""
var in_transform_block = false  # 是否在 transform 块中
#场景信息
var scene_dic_list :Dictionary:
	set(value):
		scene_dic_list = value
		GlobalDict.scene_dic_list = scene_dic_list
var scene_num=0
#角色信息
var character_dic_list :Dictionary:
	set(value):
		character_dic_list = value
		GlobalDict.character_dic_list = character_dic_list
var character_simp_list = []
var character_num = 0
var temp_path:String
var label_all = []


#信息修改相关
var script_shown_entry_map = {}
var script_word_entry_map = {}
var script_scene_entry_map = {}
var character_button_map= {}
var character_emo_button_map= {}
var scene_button_map= {}
var current_selected_character_key:String
var current_selected_emo_key:String
var current_selected_scene_key:String
var current_selected_transform_key:String
var temp_scene_name:String
var temp_key:String
var temp_name:String
var temp_color:Color



#节点拖动相关
var dragging_node:Control:
	set(value):
		dragging_node = value
		if dragging_node:
			$CanvasLayer/Label.set_text(value.get_name())
var drag_preview:Control




#节点预加载
@onready var character_button_tscn = preload("res://按钮/character_button.tscn")
@onready var scene_button_tscn = preload("res://按钮/scene_button.tscn")
@onready var transform_button_tscn = preload("res://按钮/transform_button.tscn")
@onready var emo_button_tscn = preload("res://按钮/character_emo_button.tscn")
@onready var transform_detail_ent_tscn = preload("res://节点/transform_detail_ent.tscn")
@onready var show_ent_tscn = preload("res://节点/scipt_show.tscn")
@onready var label_ent_tscn = preload("res://节点/scipt_label.tscn")
@onready var chat_ent_tscn = preload("res://节点/scipt_word.tscn")
@onready var scene_ent_tscn = preload("res://节点/scipt_scene_ent.tscn")

var scene_ent_template = null
var show_ent_template = null

#裁剪头像相关
var current_rect:Rect2
func _ready() -> void:
	singal_init()
	transform_init()
func singal_init():
	icon_crop_window.connect("texture_send", Callable(self, "emo_icon_set").bind(icon_crop_window.icon))

func contains_name(target_name: String) -> bool:
	for dict in character_dic_list:
		if dict.get("name", "") == target_name:
			return true
	return false

func _on_导入按钮_pressed() -> void:
	file_dialog.popup()

func _on_保存按钮_pressed() -> void:
	if current_file_path != "":
		save_confim.popup()
		
	else:
		#warning_window.dialog_text = "未选择文件路径!"
		#warning_window.popup()
		TextFloating.display_text("未选择文件路径!",25,get_global_mouse_position())
	
func _on_另存为按钮_pressed() -> void:
	file_dialog.popup()

func _on_路径选择_file_selected(path: String) -> void:
	current_file_path = path
	path_input.text = current_file_path
	# TODO: Read the file content and parse it

func _on_当前文件路径_text_submitted(new_text: String) -> void:
	if path_input.text == new_text:
		temp_path = path_input.text
		path_change_confim.popup()
		
func _on_路径修改确认窗口_confirmed() -> void:
	current_file_path = temp_path
func _on_路径修改确认窗口_canceled() -> void:
	path_input.text = current_file_path

func _on_保存确认窗口_confirmed() -> void:
	var content = generate_file_content()
	var file = FileAccess.open(current_file_path, FileAccess.WRITE)
	file.store_string(content)
	file.close()
	print("文件已保存: ", current_file_path)
# 生成要保存的内容
func generate_file_content() -> String:
	var content = ""
	# 遍历脚本浏览面板中的所有条目，生成新的脚本内容
	for child in script_browse.get_children():
		content += child.text + "\n"
	return content

func _on_开始编辑_pressed() -> void:
	#节点清空
	character_num = 0
	character_dic_list = {}
	scene_num = 0
	scene_dic_list = {}
	current_selected_character_key = ""
	current_selected_emo_key = ""
	current_selected_scene_key = ""
	current_selected_transform_key = ""
	character_simp_list = []
	character_num = 0
	temp_path=""
	label_all = []


	#信息修改相关
	script_shown_entry_map = {}
	script_word_entry_map = {}
	script_scene_entry_map = {}
	character_button_map= {}
	character_emo_button_map= {}
	scene_button_map= {}
	current_transform = {}
	
	$"左侧栏/节点选择器/场景/ScrollContainer/VBoxContainer".init_active_button()
	$"左侧栏/节点选择器/角色/ScrollContainer/VBoxContainer".init_active_button()
	$"左侧栏/节点选择器/变换/Transform_Panel/VBoxContainer".init_active_button()
	$"左侧栏/节点选择器/变换/Position_Panel/VBoxContainer".init_active_button()
	temp_scene_name=""
	temp_key=""
	temp_name=""
	temp_color=Color()
	
	for child in script_browse.get_children():
		script_browse.remove_child(child)
		child.queue_free()
	for child in position_list.get_children():
		position_list.remove_child(child)
		child.queue_free()
	for child in emo_browse.get_children():
		emo_browse.remove_child(child)
		child.queue_free()
	character_details_key.text = ""
	character_details_name.text = ""
	character_details_color_rect.color = Color(0,0,0,255)
	parse_rpy_file(current_file_path)

func transform_init():
	transform_dic_list = {}
	for child in transform_list.get_children():
		transform_list.remove_child(child)
		child.queue_free()
	for child in position_list.get_children():
		position_list.remove_child(child)
		child.queue_free()
	for key in init_transform_dic.keys():
		transform_dic_list[init_transform_dic[key][1]] = {}
		transform_dic_list[init_transform_dic[key][1]]["trans"] = {}
		transform_dic_list[init_transform_dic[key][1]]["key"] = init_transform_dic[key][1]
		transform_dic_list[init_transform_dic[key][1]]["name"] = init_transform_dic[key][0]
		transform_dic_list[init_transform_dic[key][1]]["type"] = "default"
		add_transform_to_list(init_transform_dic[key][1],init_transform_dic[key][0])











################################################################################
#######TODO###########TODO###########TODO###########TODO#############TODO####
################################################################################
#文本解析
################################################################################
#######TODO###########TODO###########TODO###########TODO#############TODO####
################################################################################

# 文件解析函数
func parse_rpy_file(file_path: String):
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		file.close()
		process_file_content(content)
	else:
		print("文件不存在: ", file_path)

# 处理文件内容，解析角色和脚本
func process_file_content(content: String):
	var lines = Array(content.split("\n").duplicate())
	#var in_character_define = false
	#var scipt_lines = Array()
	for line in lines:	
		# 简单解析角色定义
		if line.begins_with("define"):
			line = line.strip_edges()
			parse_character_define(line)
			lines.erase(line)
		elif line.begins_with("image"):	
			line = line.strip_edges()
			parse_image_define(line)
			lines.erase(line)
		#elif line.begins_with("transform"):	
			#parse_transform_define(line)
		elif line.begins_with("transform"):
			set_transform_name(line)
			#lines.erase(line)
		elif in_transform_block:
			parse_transform_define(line)
			lines.erase(line)
	init_character_list()
	init_scene_list()
	init_trans_list()
	
	prepare_shown_entry_template()
	prepare_scene_entry_template()
	for line in lines:	
		line = line.strip_edges()
		add_script_item(line)
	
	
func init_character_list():
	for child in character_list.get_children():
		character_list.remove_child(child)
		child.queue_free()
		
	for character_key in character_dic_list.keys():
		if character_dic_list[character_key]["img"].keys().size()>1:
			if character_dic_list[character_key]["img"]["none"]["path"]=="none":
				character_dic_list[character_key]["img"].erase("none")
		add_character_to_list(character_dic_list[character_key])
		var emo_id = 0
		for emo_key in character_dic_list[character_key]["img"].keys():
			character_dic_list[character_key]["img"][emo_key]["id"] = emo_id
			emo_id = emo_id+1

func init_scene_list():
	for child in scene_list.get_children():
		scene_list.remove_child(child)
		child.queue_free()
		
	for scene_key in scene_dic_list.keys():
		add_scene_to_list(scene_dic_list[scene_key])

func init_trans_list():
	for child in transform_list.get_children():
		transform_list.remove_child(child)
		child.queue_free()
	for child in position_list.get_children():
		position_list.remove_child(child)
		child.queue_free()
	for transform_key in transform_dic_list.keys():
		add_transform_to_list(transform_key,transform_key)
		

# 预设角色选项到 shown_entry 模板
func prepare_shown_entry_template():
	#if show_ent_template!= null:
		#return show_ent_template
	show_ent_template = preload("res://节点/scipt_show.tscn").instantiate()
	prepare_position_selecter(show_ent_template)
	prepare_show_entry_character_selecter(show_ent_template)
	return show_ent_template

func prepare_position_selecter(node:Script_Shown):
	var position_select = node.get_node("Position_Select")  # 提取节点
	# 清空以防重复添加
	position_select.clear()
	for transform_key in transform_dic_list.keys():
		if transform_dic_list[transform_key]["type"] == "position":
			position_select.add_item(transform_key)

func prepare_show_entry_character_selecter(node:Script_Shown):
	var character_select = node.get_node("Character_Select")
	character_select.clear()
	for character_key in character_dic_list.keys():
		var character_name = character_dic_list[character_key]["name"]
		var character_id = character_dic_list[character_key]["id"]
		character_select.add_item(character_name, character_id)

# 预设场景选项到 scene_entry 模板
func prepare_scene_entry_template():
	#if scene_ent_template!= null:
		#return scene_ent_template
	scene_ent_template = preload("res://节点/scipt_scene_ent.tscn").instantiate() # 清空以防重复添加
	prepare_scene_entry_scene_selecter(scene_ent_template)
	# 预设完成后销毁示例对象
	return scene_ent_template

func prepare_scene_entry_scene_selecter(node:Script_Scene):
	var scene_select = node.get_node("scene_select")
	scene_select.clear()
	for scene_key in scene_dic_list.keys():
		var scene_name = scene_dic_list[scene_key]["key"]
		var scene_id = scene_dic_list[scene_key]["id"]
		scene_select.add_item(scene_key, scene_id)
		scene_select.set_item_icon(scene_id,scene_dic_list[scene_key]["small_tex"])
















################################################################################
#######TODO###########TODO###########TODO###########TODO#############TODO####
################################################################################
#逐句分析
################################################################################
#######TODO###########TODO###########TODO###########TODO#############TODO####
################################################################################



# 解析 define character 语句
func parse_character_define(line: String) -> Dictionary:
	var character = {}
	#var image = {}
	# 处理 define character 部分
	# 提取键值和名称（支持带有颜色定义的格式）
	var character_define_regex = RegEx.new()
	character_define_regex.compile("define\\s+(?P<key>\\w+)\\s*=\\s*Character\\(\\s*\"(?P<name>.*?)\"(?:,\\s*who_color=\"(?P<color>#[0-9a-fA-F]{6})\")?(?:,\\s*image=\"(?P<image>.*?)\")?(?:,\\s*callback=(?P<callback>\\w+))?(?:,\\s*what_suffix=\"(?P<suffix>.*?)\")?(?:,\\s*cb_name='(?P<cb_name>\\w+)')?\\)")
	var result = character_define_regex.search(line)
	if result:
		var tem_img_dic = null_img_dic.duplicate()
		character.key = result.get_string("key")
		character.name = result.get_string("name")
		character.color = result.get_string("color")
		character.id = character_num
		character.img = {}
		character.img_rect = Rect2()
		character_dic_list[character.key] = character
		character_dic_list[character.key]["img"]["none"] = tem_img_dic
		script_word_entry_map[character.key] = []
		script_shown_entry_map[character.key] = []
		
		character_num = character_num+1
		#print(character_dic_list[character.key])
		
	#print(character)
	return character
#读取图片	
func load_img(path):
	var image = Image.new()
	image.load(path)
	var texture = ImageTexture.new()
	texture.set_image(image)
	return texture
#裁剪出缩略图
func create_thumbnail(imgtex:ImageTexture) -> Texture2D:
	var img = imgtex.get_image()
	if img.get_width()>0:
		#var crop_size = img.get_size().x
		#img.crop(crop_size, crop_size)  # 裁剪为方形
		##img.resize(60,60,Image.INTERPOLATE_BILINEAR)
		#var thumbnail = ImageTexture.new()
		#thumbnail.set_image(img)
		#return thumbnail
	#return null
		var crop_x =  img.get_width()/ 3
		var crop_y = 0.25*abs(img.get_height() - 2*img.get_width())
		# 计算裁剪区域大小
		var crop_size = img.get_height() / 6
		# 创建裁剪后的图像
		var thumbnail = ImageTexture.new()
		img.blit_rect(img, Rect2(crop_x, crop_y, crop_size, crop_size), Vector2(0, 0))
		img.crop(crop_size, crop_size)
		thumbnail.set_image(img)
		return thumbnail
	return null
#等比缩小为固定高度
func reduce_img(imgtex:ImageTexture,height) -> Texture2D:
	var img = imgtex.get_image()
	# 创建裁剪后的图像
	var thumbnail = ImageTexture.new()
	img.resize(img.get_size().x*height/img.get_size().y,height)
	thumbnail.set_image(img)
	return thumbnail
	#纯色纹理生成
func color_texture_make(color):
	var image = Image.new()
	image.load("res://tex/10040101.png")
	image.fill(Color(color))
	
	var color_texture = ImageTexture.new()
	color_texture.set_image(image)
	return color_texture
#解析立绘设置
func parse_image_define(line):
	var image = {}
	var character = {}
	var image_define_regex = RegEx.new()
	image_define_regex.compile("image\\s+(?P<character_key>\\w+)\\s+(?P<image_emo_key>\\w+)\\s*=\\s*Image\\(\"(?P<image_path>.*?)\"(?:,\\s*xanchor=(?P<xanchor>[\\d.]+))?(?:,\\s*yanchor=(?P<yanchor>[\\d.]+))?\\)")
	# 场景图片定义正则表达式，没有情感关键字
	var scene_define_regex = RegEx.new()
	scene_define_regex.compile("image\\s+(?P<scene_key>\\w+)\\s*=\\s*\"(?P<scene_path>.*?)\"")
	var scene_result = scene_define_regex.search(line)
	var result = image_define_regex.search(line)
##	人物立绘定义生成
	if result:
		var character_key = result.get_string("character_key")
		image.key = result.get_string("image_emo_key")
		image.path = result.get_string("image_path")
		image.tex = load_img(image.path)
		image.icon = create_thumbnail(image.tex)
		image.id = character_dic_list[character_key]["img"].size()
		# 如果字典中没有角色，创建新角色条目
		if not character_dic_list.has(character_key):
			var tem_img_dic = null_img_dic.duplicate()
			character.key = result.get_string("key")
			character.name = result.get_string("name")
			character.color = result.get_string("color")
			character.id = character_num
			character.img = {}
			character.img_rect = Rect2()
			character_dic_list[character.key] = character
			character_num = character_num+1
			character_dic_list[character.key]["img"]["none"] = tem_img_dic
		character_dic_list[character_key]["img"][image.key] = image
		#print(character_dic_list[character_key])
##	场景立绘定义生成
	elif scene_result:
		#print(scene_result.get_string("scene_path"))
		script_scene_entry_map[scene_result.get_string("scene_key")] = []
##	纯色
		if scene_result.get_string("scene_path").begins_with("#"):
			var scene_image = {}
			scene_image.key = scene_result.get_string("scene_key")
			scene_image.name = scene_image.key
			scene_image.path = "null"
			var temp_color = Color(scene_result.get_string("scene_path"))
			scene_image.tex = color_texture_make(temp_color)
			scene_image.small_tex = reduce_img(scene_image.tex,64)
			scene_image.id = scene_num
			scene_num = scene_num+1
			scene_dic_list[scene_image.key] = scene_image
##	场景
		else:
			var scene_image = {}
			scene_image.key = scene_result.get_string("scene_key")
			scene_image.name = scene_image.key
			scene_image.path = scene_result.get_string("scene_path")
			scene_image.tex = load_img(scene_image.path)
			scene_image.small_tex = reduce_img(scene_image.tex,64)
			scene_image.id = scene_num
			scene_num = scene_num+1
			scene_dic_list[scene_image.key] = scene_image
#变换初始化
func set_transform_name(line:String):
	var transform_start_regex = RegEx.new()
	transform_start_regex.compile("transform\\s+(?P<transform_key>\\w+):\\s*$")
	var result = transform_start_regex.search(line)
	if result:
		# 开始新的 transform 块
		current_transform_key = result.get_string("transform_key")
		transform_dic_list[current_transform_key] = {}
		transform_dic_list[current_transform_key]["trans"] = {}
		transform_dic_list[current_transform_key]["key"] = current_transform_key
		transform_dic_list[current_transform_key]["name"] = current_transform_key
		transform_dic_list[current_transform_key]["type"] = "general"
		in_transform_block = true
#变换解析
func parse_transform_define(line:String):
	if line.begins_with(" ") or line.begins_with("\t"):  # 若有缩进，视为 transform 参数行
		#print(line)
		var parts = line.strip_edges().split(" ")
		#print(parts)
		if parts.size() > 2:
			for i in range(0, parts.size(), 2):
				var key = parts[i]
				if key=="xpos" or key=="ypos" or key=="xanchor" or key=="yanchor" or key=="xalign" or key=="yalign" or key=="xcenter" or key=="ycenter":
					if transform_dic_list[current_transform_key]["type"] != "position":
						transform_dic_list[current_transform_key]["type"] = "position"
						transform_dic_list[current_transform_key]["trans"]["xpos"] =0
						transform_dic_list[current_transform_key]["trans"]["ypos"] =0
						transform_dic_list[current_transform_key]["trans"]["xanchor"] =0
						transform_dic_list[current_transform_key]["trans"]["yanchor"] =0
						transform_dic_list[current_transform_key]["trans"]["xalign"] =0
						transform_dic_list[current_transform_key]["trans"]["yalign"] =0
						transform_dic_list[current_transform_key]["trans"]["xcenter"] =0
						transform_dic_list[current_transform_key]["trans"]["ycenter"] =0
						transform_dic_list[current_transform_key]["trans"]["xzoom"] =0
						transform_dic_list[current_transform_key]["trans"]["yzoom"] =0
						transform_dic_list[current_transform_key]["trans"]["rotate"] =0
				var value = float(parts[i + 1])
				transform_dic_list[current_transform_key]["trans"][key] = value
				
					
		elif parts.size() == 2:
			# 单参数行的情况
			var key = parts[0]
			if key=="xpos" or key=="ypos" or key=="xanchor" or key=="yanchor" or key=="xalign" or key=="yalign" or key=="xcenter" or key=="ycenter":
				if transform_dic_list[current_transform_key]["type"] != "position":
					transform_dic_list[current_transform_key]["type"] = "position"
					transform_dic_list[current_transform_key]["trans"]["xpos"] =0
					transform_dic_list[current_transform_key]["trans"]["ypos"] =0
					transform_dic_list[current_transform_key]["trans"]["xanchor"] =0
					transform_dic_list[current_transform_key]["trans"]["yanchor"] =0
					transform_dic_list[current_transform_key]["trans"]["xalign"] =0
					transform_dic_list[current_transform_key]["trans"]["yalign"] =0
					transform_dic_list[current_transform_key]["trans"]["xcenter"] =0
					transform_dic_list[current_transform_key]["trans"]["ycenter"] =0
					transform_dic_list[current_transform_key]["trans"]["xzoom"] =0
					transform_dic_list[current_transform_key]["trans"]["yzoom"] =0
					transform_dic_list[current_transform_key]["trans"]["rotate"] =0
			var value = float(parts[1])
			transform_dic_list[current_transform_key]["trans"][key] = value
			
	else:
		# 非缩进行表示 transform 块结束，保存当前 transform 定义
		in_transform_block = false











################################################################################
#######TODO###########TODO###########TODO###########TODO#############TODO######
################################################################################
#右侧栏显示
################################################################################
#######TODO###########TODO###########TODO###########TODO#############TODO######
################################################################################

#更新右侧栏人物选项
func update_emotion_panel(character):
	#var character_key = character["key"]
	# 清空面板中的旧情感
	character_emo_button_map[character["key"]] = Array()
	for child in emo_browse.get_children():
		emo_browse.remove_child(child)
		child.queue_free()
		character_image.set_texture(null)
		
	if character["img"]:
		for emo_key in character["img"].keys():
			# 将情感和立绘添加到面板
			add_emo_button(character,emo_key)
			
		_on_emo_img_selected(character["img"][emo_browse.get_child(0).emo_key])
		
#添加立绘差分按钮
func add_emo_button(character,emo_key):
	var chara_emo_but = emo_button_tscn.instantiate()
	chara_emo_but.connect("pressed", Callable(self, "_on_emo_img_selected").bind(character["img"][emo_key]))
	chara_emo_but.connect("button_down", Callable($"右侧栏/Character_Panel/立绘展示面板/差分选择面板/ScrollContainer", "_on_node_mouse_down").bind(chara_emo_but,"pressed"))
	chara_emo_but.set_tooltip_text(emo_key)
	emo_browse.add_child(chara_emo_but)

	character_emo_button_map[character["key"]].append(chara_emo_but)
	chara_emo_but.emo_key = emo_key
	chara_emo_but.character_key = character["key"]
	if character["img"]:
		chara_emo_but.tex.set_texture(character["img"][emo_key]["icon"])
	else:
		chara_emo_but.tex.set_texture(ImageTexture.new())

# 当立绘选项被选中时，贴上对应立绘
func _on_emo_img_selected(emo_img):
	#character_details_name.text = "角色名: " + character["name"]
	#print("立绘选择", emo_img["tex"])
	current_selected_emo_key = emo_img["key"]
	character_image.set_texture(emo_img["tex"])
	emo_label.set_text("立绘值："+emo_img["key"])











################################################################################
#######TODO###########TODO###########TODO###########TODO#############TODO#######
################################################################################
#角色面板显示
################################################################################
#######TODO###########TODO###########TODO###########TODO#############TODO#######
################################################################################

# 将解析的角色添加到角色列表
func add_character_to_list(character: Dictionary):
	#print(character)
	var button = character_button_tscn.instantiate()
	button.text = character["name"]
	#var first_icon = ImageTexture.new()
	button.connect("pressed", Callable(self, "_on_character_selected").bind(character))
	button.connect("pressed", Callable(character_list, "_on_button_pressed").bind(button))
	button.connect("button_down", Callable($"左侧栏/节点选择器/角色/ScrollContainer", "_on_node_mouse_down").bind(button,"pressed"))
	#button.connect("button_up", Callable($"左侧栏/节点选择器/角色/ScrollContainer", "_on_node_mouse_up").bind(button,"released"))
	character_list.add_child(button)

	button.character_key = character["key"]
	button.change_color(character["color"])
	#print(character["name"])
	if character["img"]:
		for emo_key in character["img"].keys():
			#print(emo_key)
			button.tex.set_texture(character["img"][emo_key]["icon"])
			break
	#按钮添加进按钮字典
	character_button_map[character["key"]] = button

# 当角色被选中时，更新角色详细信息面板
func _on_character_selected(character: Dictionary):
	character_details_name.text = character["name"]
	character_details_key.text = character["key"]
	character_details_color_rect.color = Color(character["color"])
	# TODO: 更新立绘信息
	update_emotion_panel(character)
	current_selected_character_key = character["key"]











################################################################################
#######TODO###########TODO###########TODO###########TODO#############TODO#######
################################################################################
#场景面板显示
################################################################################
#######TODO###########TODO###########TODO###########TODO#############TODO#######
################################################################################



func add_scene_to_list(scene):
	var button = scene_button_tscn.instantiate()
	scene_list.add_child(button)
	button.tex.set_texture(scene["tex"])
	button.set_text(scene["name"])
	button.connect("pressed", Callable(self, "_on_scene_selected").bind(scene))
	button.connect("pressed", Callable(scene_list, "_on_button_pressed").bind(button))
	button.connect("button_down", Callable($"左侧栏/节点选择器/场景/ScrollContainer", "_on_node_mouse_down").bind(button,"pressed"))
	button.scene_key = scene["key"]
	scene_button_map[scene["key"]] = button
func _on_scene_selected(sence):
	current_selected_scene_key = sence["key"]
	temp_scene_name = sence["name"]
	scene_name_edit.text = sence["name"]
	scene_key_label.text = sence["key"]
	scene_tex_show.set_texture(sence["tex"])
func _on_场景名line_2d_text_submitted(new_text: String) -> void:
	if new_text!="":
		scene_dic_list[current_selected_scene_key]["name"]= new_text
		for key in scene_button_map.keys():
			
			if scene_button_map[key].scene_key == current_selected_scene_key:
				scene_button_map[key].set_texture(new_text)
				return
	else:
		TextFloating.display_text("名称为空!",25,scene_name_edit.position)
		scene_name_edit.text = temp_scene_name











################################################################################
#######TODO###########TODO###########TODO###########TODO#############TODO#######
################################################################################
#变换面板显示
################################################################################
#######TODO###########TODO###########TODO###########TODO#############TODO#######
################################################################################

func add_transform_to_list(transform_key,name):
	var button = transform_button_tscn.instantiate()
	button.transform_key = transform_key
	button.set_text(name)
	if transform_dic_list[transform_key]["type"]=="position":
		position_list.add_child(button)
		button.connect("pressed", Callable(position_list, "_on_button_pressed").bind(button))
		button.connect("button_down", Callable($"左侧栏/节点选择器/变换/Position_Panel", "_on_node_mouse_down").bind(button,"pressed"))
	else:
		transform_list.add_child(button)
		button.connect("pressed", Callable(transform_list, "_on_button_pressed").bind(button))
		button.connect("button_down", Callable($"左侧栏/节点选择器/变换/Transform_Panel", "_on_node_mouse_down").bind(button,"pressed"))
	match(transform_dic_list[transform_key]["type"]):
		"general":
			button.set_type("general")
		"scene":
			button.set_type("scene")
		"character":
			button.set_type("general")
		"position":
			button.set_type("position")
		"default":
			button.set_type("default")
		"default_position":
			button.set_type("default_position")
	if transform_dic_list[transform_key]["type"] =="default" or transform_dic_list[transform_key]["type"] =="default_position":
		button.default_bool = true
	button.connect("pressed", Callable(self, "_on_transform_selected").bind(transform_key))

func _on_transform_selected(transform_key):
	$"右侧栏/Transform_Panel/Label".hide()
	current_selected_transform_key = transform_key
	trans_key_label.set_text(transform_key)
	trans_name_edit.set_text(transform_dic_list[transform_key]["name"])
	for child in trans_detail_list.get_children():
		trans_detail_list.remove_child(child)
		child.queue_free()
	if transform_dic_list[transform_key]["type"] =="default" or transform_dic_list[transform_key]["type"] =="default_position":
		$"右侧栏/Transform_Panel/Label".show()
	else:
		for child in trans_detail_list.get_children():
			trans_detail_list.remove_child(child)
			child.queue_free()
		
		for parameter in transform_dic_list[current_selected_transform_key]["trans"].keys():
			var detail_ent = transform_detail_ent_tscn.instantiate()
			trans_detail_list.add_child(detail_ent)
			
			detail_ent.transform_key = current_selected_transform_key
			detail_ent.parameter_key = parameter
			detail_ent.transform_select.set_text(parameter)
			detail_ent.transform_value.set_value(transform_dic_list[current_selected_transform_key]["trans"][parameter])
		
func _on_变换名line_2d_text_submitted(new_text: String) -> void:
	transform_dic_list[current_selected_transform_key]["name"] = trans_name_edit.get_text()
	for button in transform_list.get_children()+position_list.get_children():
		button.set_text(transform_dic_list[current_selected_transform_key]["name"])
		
func _on_变换添加按钮_pressed() -> void:
	transform_newone_window.popup()

func _on_新建变换输入窗口_confirmed() -> void:
	var new_key:String = transform_newone_window.key_line.get_text()
	for key in transform_dic_list.keys():
		if key == new_key:
			TextFloating.display_text("键值重复!",25,get_global_mouse_position())
			return
	if new_key.is_valid_identifier():
		transform_dic_list[new_key] ={}
		transform_dic_list[new_key]["trans"] ={}
		transform_dic_list[new_key]["key"] = new_key
		transform_dic_list[new_key]["name"] = transform_newone_window.name_line.get_text()
		match(transform_newone_window.trans_type.get_item_id(transform_newone_window.trans_type.get_selected_id())):
			0:
				transform_dic_list[new_key]["type"] = "general"
			1:
				transform_dic_list[new_key]["type"] = "scene"
			2:
				transform_dic_list[new_key]["type"] = "character"
			3:
				transform_dic_list[new_key]["type"] = "position"
				transform_dic_list[new_key]["trans"]["xpos"] = 0
				transform_dic_list[new_key]["trans"]["ypos"] = 0
				transform_dic_list[new_key]["trans"]["xzoom"] = 0
				transform_dic_list[new_key]["trans"]["yzoom"] = 0
	else:
		TextFloating.display_text("键值非法!",25,get_global_mouse_position())
		return
	add_transform_to_list(new_key,transform_dic_list[new_key]["name"])
	transform_newone_window.key_line.set_text()
	transform_newone_window.name_line.set_text()
	
func _on_添加变换参数按钮_pressed() -> void:
	if transform_dic_list[current_selected_transform_key]["type"]=="position":
		TextFloating.display_text("角色位置变换参数固定!",25,get_global_mouse_position())
		return









################################################################################
#######TODO###########TODO###########TODO###########TODO#############TODO#######
################################################################################
#脚本面板显示
################################################################################
#######TODO###########TODO###########TODO###########TODO#############TODO#######
################################################################################

 ##	处理并添加脚本条目
func add_script_item(line: String):
	var line_part = line.split(" ",false)
	
	## 解析对话和指令
#################################################################################
##标签
	if line.begins_with("label"):
		label_ent_make(line_part)
		#print("label",line_part)
#################################################################################	
## 显示/隐藏节点
	elif line.begins_with("show")||line.begins_with("hide"):
		show_ent_make(line_part)
#################################################################################		
##场景节点
	elif line.begins_with("scene"):
		scene_ent_make(line_part)
#################################################################################		
## 发言节点
	for key in character_dic_list:
		#print(typeof(key))
		if line.begins_with(key):
			var speak_part = parse_dialogue(line)
			chat_ent_make(key,speak_part)

#生成章节标签节点
func label_ent_make(line_part):
	var label_ent = label_ent_tscn.instantiate()
	label_all.append(line_part[1])
	script_browse.add_child(label_ent)
	label_ent.name_label.text = line_part[1].rstrip(":")
	return label_ent
	
#生成显示节点
func show_ent_make(line_part):
	var show_ent = show_ent_template.duplicate()
	script_browse.add_child(show_ent)
	show_ent.connect("mouse_entered", Callable($Script_Browse/ScrollContainer, "on_mouse_enter_node").bind(show_ent))
	show_ent.connect("mouse_exited", Callable($Script_Browse/ScrollContainer, "on_mouse_exited_node").bind(show_ent))
	show_ent.character_key = line_part[1]
	script_shown_entry_map[line_part[1]].append(show_ent)
	#第一项
	if line_part[0] =="show":
		show_ent.show_select._select_int(0)
	else:
		show_ent.show_select._select_int(1)
	#角色项
	if line_part[2] !="at":
		show_ent.tex.set_button_icon(character_dic_list[line_part[1]]["img"][line_part[2]]["icon"])
	#for key in character_dic_list:
		#show_ent.character_select.add_item(character_dic_list[key]["name"],int(character_dic_list[key]["id"]))
	show_ent.character_select._select_int(character_dic_list[line_part[1]]["id"])
	#show_ent.color_show.set_color(character_dic_list[line_part[1]]["color"])
	
	show_ent.position_select._select_int(-1)
	if line_part.size()>=6:
		show_ent.transform_select._select_int(transfrom_check(line_part[5],show_ent.transform_select))
	#图标和差分项
	for emo_key in character_dic_list[line_part[1]]["img"]:
		show_ent.emo_select.add_item(emo_key,character_dic_list[line_part[1]]["img"][emo_key]["id"])
	if line_part[2]!= "at":
		show_ent.tex.set_button_icon(character_dic_list[line_part[1]]["img"][line_part[2]]["icon"])
		show_ent.emo_select._select_int(int(character_dic_list[line_part[1]]["img"][line_part[3]]["id"]))
	else:
		for emo_key in character_dic_list[line_part[1]]["img"].keys():
			show_ent.tex.set_button_icon(character_dic_list[line_part[1]]["img"][emo_key]["icon"])
			break
		
		show_ent.emo_select._select_int(0)
	return show_ent
	
#生成场景节点
func scene_ent_make(line_part):
	var scene_ent = scene_ent_template.duplicate()
	script_browse.add_child(scene_ent)
	scene_ent.connect("mouse_entered", Callable($Script_Browse/ScrollContainer, "on_mouse_enter_node").bind(scene_ent))
	scene_ent.connect("mouse_exited", Callable($Script_Browse/ScrollContainer, "on_mouse_exited_node").bind(scene_ent))
	scene_ent.set_texture(scene_dic_list[line_part[1]]["tex"])
	scene_ent.scene_select._select_int(scene_dic_list[line_part[1]]["id"])
	scene_ent.scene_key = line_part[1]
	script_scene_entry_map[line_part[1]].append(scene_ent)
	
	#print(scene_ent.tex.position)
	##TODO 变换
	return scene_ent

#生成对话节点
func chat_ent_make(key,speak_part):
	var chat_ent = chat_ent_tscn.instantiate()
	script_browse.add_child(chat_ent)
	script_word_entry_map[key].append(chat_ent)
	chat_ent.character_key = key
	chat_ent.connect("mouse_entered", Callable($Script_Browse/ScrollContainer, "on_mouse_enter_node").bind(chat_ent))
	chat_ent.connect("mouse_exited", Callable($Script_Browse/ScrollContainer, "on_mouse_exited_node").bind(chat_ent))

	##检测发言差分
	#无emo差分提示则继承上一次
	if speak_part["emo"]!=null:
		chat_ent.tex.set_button_icon(character_dic_list[speak_part["speaker"]]["img"][speak_part["emo"]]["icon"])
		#缩略图
		for emo_key in character_dic_list[speak_part["speaker"]]["img"]:
			chat_ent.emo_select.add_item(emo_key,character_dic_list[speak_part["speaker"]]["img"][emo_key]["id"])
		chat_ent.emo_select._select_int(int(character_dic_list[speak_part["speaker"]]["img"][speak_part["emo"]]["id"]))
	#有emo差分
	else:
		for emo_key in character_dic_list[key]["img"].keys():
			chat_ent.tex.set_button_icon(character_dic_list[speak_part["speaker"]]["img"][emo_key]["icon"])
			break
		for emo_key in character_dic_list[speak_part["speaker"]]["img"]:
			chat_ent.emo_select.add_item(emo_key,character_dic_list[speak_part["speaker"]]["img"][emo_key]["id"])
		chat_ent.emo_select._select_int(0)

	chat_ent.color_show.set_color(character_dic_list[key]["color"])
	chat_ent.word.text = speak_part["content"]
	chat_ent.name_label.text = character_dic_list[key]["name"]
	
	##TODO 变换
	return chat_ent
	
	# 解析说话内容
func parse_dialogue(line: String) -> Dictionary:
	var dialogue = {}
	if "\"" in line:
		var array= line.split("\"",false)
		var speaker = array[0].strip_edges()
		var content = array[1].strip_edges()
		var transform = null
		if array.size()>2:
			transform = array[2].strip_edges()
		if " " in speaker:
			var speaker_part = speaker.split(" ",false)
			dialogue["speaker"] = speaker_part[0]
			dialogue["emo"] = speaker_part[1]
		else:
			dialogue["speaker"] = speaker
			dialogue["emo"] = null
		dialogue["content"] = content
		if transform:
			var transform_part = transform.split(" ",false)
			dialogue["transform"] = transform_part[1]
		else:
			dialogue["transform"] = ""
	return dialogue

func transfrom_check(search_text,button):
	for i in range(button.get_item_count()):
		if button.get_item_text(i) == search_text:
			return i  # 如果找到了该文本，返回其 ID
			
	# 如果没有找到该文本，则添加新的选项
	var new_id = button.get_item_count()  # 获取新选项的 ID
	button.add_item(search_text, new_id)  # 添加新选项
	return new_id  # 返回新添加的选项的 ID
#










################################################################################
#######TODO###########TODO###########TODO###########TODO#############TODO#######
################################################################################
##角色详情面板 对 角色 信息的修改
################################################################################
#######TODO###########TODO###########TODO###########TODO#############TODO#######
################################################################################

func _on_拾色器_color_changed(color:Color) -> void:
	temp_color = $"右侧栏/Character_Panel/Message_Panel/颜色/拾色器".get_pick_color()
	color_change_confim.popup()
func _on_角色名line_2d_text_submitted(new_text: String) -> void:
	temp_name = new_text
	name_change_confim.popup()

func _on_角色名改变确认窗口_confirmed() -> void:
	character_dic_list[current_selected_character_key]["name"]= temp_name
	on_character_info_changed(current_selected_character_key,"name",temp_name)
func _on_角色名改变确认窗口_canceled() -> void:
	character_details_name.text = character_dic_list[current_selected_character_key]["name"]
	temp_name = String()

func _on_颜色改变确认窗口_confirmed() -> void:
	character_dic_list[current_selected_character_key]["color"]= temp_color
	on_character_info_changed(current_selected_character_key,"color",temp_color)
func _on_颜色改变确认窗口_canceled() -> void:
	character_details_name.text = character_dic_list[current_selected_character_key]["name"]
	temp_color = Color()

func _on_add_emo_button_pressed() -> void:
	emo_name_editer_window.popup()
func _on_差分名称输入窗口_confirmed() -> void:
	for emo_key in character_dic_list[current_selected_character_key]["img"].keys():
		if emo_name_editer_window.key_line.text == emo_key || emo_name_editer_window.key_line.text =="" ||!emo_name_editer_window.key_line.text.is_valid_identifier():
			#error_emo_add_text_window.popup()
			TextFloating.display_text("键值重复或含有无效字符!",25,get_global_mouse_position())
			emo_name_editer_window.key_line.clear()
			#emo_name_editer_window.popup()
			#emo_name_editer_window.hide()
			return
	var image = {}
	image.key = emo_name_editer_window.key_line.text
	image.path = ""
	for emo_key in character_dic_list[current_selected_character_key]["img"].keys():
		image.tex = character_dic_list[current_selected_character_key]["img"][emo_key]["tex"]
		image.icon = character_dic_list[current_selected_character_key]["img"][emo_key]["icon"]
		break
	image.id = character_dic_list[current_selected_character_key]["img"].size()
	character_dic_list[current_selected_character_key]["img"][image.key] = image
	add_emo_button(character_dic_list[current_selected_character_key],image.key)
	emo_name_editer_window.key_line.clear()

#修改角色信息中转站
func on_character_info_changed(character_key: String, field: String, new_value):
	var character_data = character_dic_list[character_key]
	character_data[field] = new_value
	# 根据字段的类型选择性地刷新对应的界面元素
	if field == "name" or field == "color":
		update_character_button_name(character_data)
		update_script_entry_name(character_data)
		prepare_shown_entry_template()
		
	elif field == "img" or field == "icon":
		# 更新缩略图和图像显示
		update_character_button_img(character_data)
		update_script_entry_img(character_data)
		

func update_character_button_name(character_data: Dictionary):
	var button = character_button_map[character_data["key"]]
	button.character_key = character_data["key"]
	# 更新按钮颜色和名称
	button.text = character_data["name"]
	
	var color = Color(character_data["color"])
	var style = StyleBoxFlat.new
	style = button.theme.get("Button/styles/normal")
	style.set_bg_color(color)
	button.theme.set("Button/styles/normal",style)
	
func update_character_button_img(character_data: Dictionary):
	var button = character_button_map[character_data["key"]]
	# 更新缩略图
	for emo_key in character_data["img"].keys():
		button.tex.set_button_icon(character_data["img"][emo_key]["icon"])
		break

#更新脚本节点——名称
func update_script_entry_name(character_data: Dictionary):
	var word_entries = script_word_entry_map[character_data["key"]]
	var shown_entries = script_shown_entry_map[character_data["key"]]
	for entry in word_entries:
		entry.character_key = character_data["key"]
		print("Sciipt_Word")
		entry.name_label.text = character_data["name"]
		entry.color_show.set_color(character_data["color"])
	
	for entry in shown_entries:
		entry.character_select.set_item_text(int(character_dic_list[character_data["key"]]["id"]),character_dic_list[character_data["key"]]["name"])
			
#更新脚本节点——图片
func update_script_entry_img(character_data: Dictionary):
	var entries = script_shown_entry_map[character_data["key"]]+script_word_entry_map[character_data["key"]]
	for button in entries:
	# 更新缩略图
		if button.emo!= "":
			button.tex.set_button_icon(character_data["img"][button.emo]["icon"])
			#缩略图
			for emo_key in character_data["img"]:
				button.emo_select.add_item(emo_key,character_data["img"][emo_key]["id"])
			button.emo_select._select_int(int(character_data["img"][button.emo]["id"]))
		else:
			for emo_key in character_data["img"].keys():
				button.tex.set_button_icon(character_data["img"][emo_key]["icon"])
				break
			for emo_key in character_data["img"]:
				button.emo_select.add_item(emo_key,character_data["img"][emo_key]["id"])











################################################################################
#######TODO###########TODO###########TODO###########TODO#############TODO#######
################################################################################
#######TODO######TODO########   裁剪ICON   #######TODO######TODO#######
################################################################################
#######TODO###########TODO###########TODO###########TODO#############TODO#######
################################################################################
func _on_icon_make_button_pressed() -> void:
	if character_dic_list[current_selected_character_key]["img"]:
		icon_crop_window.set_img(character_dic_list[current_selected_character_key]["img"][current_selected_emo_key]["tex"])
		icon_crop_window.popup()
	else:
		error_emo_add_text_window.popup()
#修改icon初始函数
func emo_icon_set(icon):
	character_dic_list[current_selected_character_key]["img"][current_selected_emo_key]["icon"] = icon
	current_rect= icon_crop_window.current_rect
	choose_apply_all_window.popup()
#按rect与比例裁剪图片
func get_cropped_texture(texture,global_rect: Rect2,) -> ImageTexture:
	var img = texture.get_image()
	var img_scale = icon_crop_window.get_size().y/texture.get_size().y
	var crop_rect = Rect2(GlobalDict.vector_multiply(global_rect.position,1/img_scale), GlobalDict.vector_multiply(global_rect.size,1/img_scale))
	img.blit_rect(img, crop_rect, Vector2(0, 0))
	img.crop(crop_rect.size.x, crop_rect.size.x)
	var cropped_texture = ImageTexture.new()
	cropped_texture.set_image(img)
	return cropped_texture
#全按rect修改
func _on_是否应用于该角色所有立绘_confirmed() -> void:
	icon_crop_window.hide()
	#录入默认裁剪区域
	var global_rect = Rect2(icon_crop_window.crop_position, icon_crop_window.crop_size)
	character_dic_list[current_selected_character_key]["img_rect"] = global_rect
	#按区域裁剪
	for emo_key in character_dic_list[current_selected_character_key]["img"].keys():
		character_dic_list[current_selected_character_key]["img"][emo_key]["icon"] = get_cropped_texture(character_dic_list[current_selected_character_key]["img"][emo_key]["tex"],global_rect)
		update_icon_emo(current_selected_character_key,emo_key)
#只修改当前
func _on_是否应用于该角色所有立绘_canceled() -> void:
	icon_crop_window.hide()
	var global_rect = Rect2(icon_crop_window.crop_position, icon_crop_window.crop_size)
	character_dic_list[current_selected_character_key]["img"][current_selected_emo_key]["icon"] = get_cropped_texture(character_dic_list[current_selected_character_key]["img"][current_selected_emo_key]["tex"],global_rect)
	#icon_crop_window.texture_rect.set_texture(ImageTexture.new())
	update_icon_emo(current_selected_character_key,current_selected_emo_key)
	
##更新单一差分的icon
func update_icon_emo(character_key,emo_key):
	var icon_temp = character_dic_list[current_selected_character_key]["img"][current_selected_emo_key]["icon"]
	update_emotion_panel(character_dic_list[current_selected_character_key])
	var temp_array = character_dic_list[current_selected_character_key]["img"].keys()
	for emo in temp_array:
			character_button_map[character_key].tex.set_texture(character_dic_list[current_selected_character_key]["img"][emo]["icon"])
			break
	for button in script_shown_entry_map[character_key]:
		if button.emo == "":
			for emo in temp_array:
				button.tex.set_button_icon(character_dic_list[current_selected_character_key]["img"][emo]["icon"])
				break
		if button.emo == emo_key:
			button.tex.set_button_icon(icon_temp)
	for button in script_word_entry_map[character_key]:
		if button.emo == "":
			for emo in temp_array:
				button.tex.set_button_icon(character_dic_list[current_selected_character_key]["img"][emo]["icon"])
				break
		if button.emo == emo_key:
			button.tex.set_button_icon(icon_temp)
	
	
func _on_image_select_button_pressed() -> void:
	image_select_window.popup()

func update_image_show_on_change_img():
	character_image.set_texture(character_dic_list[current_selected_character_key]["img"][current_selected_emo_key]["tex"])
	update_icon_emo(current_selected_character_key,current_selected_emo_key)

func _on_图片路径选择窗口_file_selected(path: String) -> void:
	character_dic_list[current_selected_character_key]["img"][current_selected_emo_key]["path"]=path
	var new_img = load_img(path)
	character_dic_list[current_selected_character_key]["img"][current_selected_emo_key]["tex"]=new_img
	if character_dic_list[current_selected_character_key]["img_rect"] ==Rect2():
		character_dic_list[current_selected_character_key]["img"][current_selected_emo_key]["icon"] = create_thumbnail(new_img)
	else:
		character_dic_list[current_selected_character_key]["img"][current_selected_emo_key]["icon"] = get_cropped_texture(new_img,character_dic_list[current_selected_character_key]["img_rect"])
	for button in emo_browse.get_children():
		if button.emo_key == current_selected_emo_key:
			button.set_button_icon(character_dic_list[current_selected_character_key]["img"][current_selected_emo_key]["icon"])
	update_image_show_on_change_img()
	prepare_shown_entry_template()










################################################################################
#######TODO###########TODO###########TODO###########TODO#############TODO#######
################################################################################
#角色面板对信息的修改
################################################################################
#######TODO###########TODO###########TODO###########TODO#############TODO#######
################################################################################

func _on_角色添加按钮_pressed() -> void:
	character_newone_window.popup()
	
func _on_新建角色窗口_confirmed() -> void:
	var new_key = character_newone_window.key_line.get_text()
	var new_name = character_newone_window.name_line.get_text()
	##TODO##
	var new_color = character_newone_window.color_line.get_pick_color()
	new_color = new_color.to_html(false)
	new_color = "#"+str(new_color)

	for key in character_dic_list.keys():
		if new_key == key || !new_key.is_valid_identifier()||new_key =="":
			character_newone_window.key_line.clear()
			#warning_key_already_have_window.popup()
			TextFloating.display_text("键值重复或含有无效字符!",25,get_global_mouse_position())
			#character_newone_window.popup()
			return
		if character_dic_list[key]["color"] == new_color:
			character_newone_window.color_line.set_pick_color(Color(0,0,0))
			#warning_key_already_have_window.popup()
			TextFloating.display_text("颜色重复!",25,get_global_mouse_position())
			#character_newone_window.popup()
			return
	new_character_add(new_key,new_name,new_color)
	prepare_shown_entry_template()
	character_newone_window.key_line.clear()
	character_newone_window.name_line.clear()
	character_newone_window.color_line.set_pick_color(Color(0,0,0))
#添加新角色
func new_character_add(new_key:String,new_name:String,new_color:Color):
	#var new_key = character_newone_window.key_line.get_text()
	#var new_name = character_newone_window.name_line.get_text()
	#var new_color = character_newone_window.color_line.get_pick_color()
	var new_character = {}
	var tem_img_dic = null_img_dic.duplicate()
	new_character.key = new_key
	new_character.name = new_name
	new_character.color = new_color
	new_character.id = character_num
	new_character.img = {}
	new_character.img_rect = Rect2()
	character_dic_list[new_key] = new_character
	character_dic_list[new_key]["img"]["none"] = tem_img_dic
	script_word_entry_map[new_key] = []
	script_shown_entry_map[new_key] = []
	character_num = character_num+1
	#print(new_character)
	add_character_to_list(new_character)
	refresh_ent_character_selecter()

func refresh_ent_character_selecter():
	for key in script_word_entry_map.keys():
		for ent in script_word_entry_map[key]:
			prepare_show_entry_character_selecter(ent)











################################################################################
#######TODO###########TODO###########TODO###########TODO#############TODO#######
################################################################################
#场景面板对信息的修改
################################################################################
#######TODO###########TODO###########TODO###########TODO#############TODO#######
################################################################################

func _on_场景添加按钮_pressed() -> void:
	scene_newone_window.popup()

func _on_新建场景窗口_confirmed() -> void:
	if scene_newone_window.key_line.get_text().is_valid_identifier()||scene_newone_window.key_line.get_text()!="":
		if scene_newone_window.name_line.get_text()!="":
			
			for key in scene_dic_list.keys():
				if key == scene_newone_window.key_line.get_text():
					TextFloating.display_text("键值重复!",25,get_global_mouse_position())
					scene_newone_window.name_line.clear()
					scene_newone_window.key_line.clear()
			new_scene_add(scene_newone_window.key_line.get_text(),scene_newone_window.name_line.get_text())
			prepare_scene_entry_template()
			
			scene_newone_window.key_line.clear()
			scene_newone_window.name_line.clear()
#添加新场景
func new_scene_add(new_key:String,new_name:String):
	var new_scene= {}
	new_scene.key = new_key
	new_scene.name = new_name
	new_scene.path = ""
	new_scene.id = scene_num
	new_scene.tex = ImageTexture.new()
	new_scene.small_tex = ImageTexture.new()
	scene_dic_list[new_key] = new_scene
	scene_num = scene_num+1
	for key in script_scene_entry_map.keys():
		for entry in script_scene_entry_map[key]:
			entry.scene_select.add_item(new_key)
			entry.scene_select.set_item_icon(new_scene.id,new_scene.small_tex)
	##给节点留空间
	script_scene_entry_map[new_key] = []
	add_scene_to_list(new_scene)
	refresh_ent_scene_selecter()
	
#选择场景图片
func _on_选择场景图片按钮_pressed() -> void:
	newscene_select_window.popup()
#
func _on_场景图片路径选择窗口_file_selected(path: String) -> void:
	var temp_tex= load_img(path)
	scene_dic_list[current_selected_scene_key]["tex"] = temp_tex
	scene_dic_list[current_selected_scene_key]["small_tex"] = reduce_img(temp_tex,64)
	scene_changed(current_selected_scene_key)
	
#场景图片更改后
func scene_changed(scene_key):
	scene_tex_show.set_texture(scene_dic_list[scene_key]["tex"])
	for key in scene_button_map.keys():
		if scene_button_map[key].scene_key == scene_key:
			scene_button_map[key].tex.set_texture(scene_dic_list[scene_key]["tex"])
	for key in script_scene_entry_map.keys():
		for entry in script_scene_entry_map[key]:
			entry.scene_select.set_item_icon(scene_dic_list[scene_key]["id"],scene_dic_list[scene_key]["small_tex"])
			if entry.scene_key ==scene_key:
				entry.set_texture(scene_dic_list[scene_key]["tex"])
	prepare_scene_entry_template()

func refresh_ent_scene_selecter():
	for key in script_scene_entry_map.keys():
		for ent in script_scene_entry_map[key]:
			prepare_scene_entry_scene_selecter(ent)









################################################################################
#######TODO###########TODO###########TODO###########TODO#############TODO#######
################################################################################
#拖动功能相关
################################################################################
#######TODO###########TODO###########TODO###########TODO#############TODO#######
################################################################################




#func _on_拾色器_button_up() -> void:
	#pass # Replace with function body.
