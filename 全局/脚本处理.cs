using Godot;
using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.IO;

public partial class Main : Control
{
	// C# 版本的@onready 和 @export 变量
	// 你需要将所有的 Godot 节点路径和导出变量迁移到 C# 脚本中
	// 例如：
	[Export] public Godot.Collections.Dictionary NullImgDic { get; set; } = new Godot.Collections.Dictionary();
	[Export] public Godot.Collections.Dictionary InitTransformDic { get; set; } = new Godot.Collections.Dictionary();

	// 信息存储相关
	public string CurrentFilePath { get; set; } = "";
	public Dictionary<string, CharacterData> CharacterDicList { get; set; } = new Dictionary<string, CharacterData>();
	public Dictionary<string, SceneData> SceneDicList { get; set; } = new Dictionary<string, SceneData>();
	public Dictionary<string, TransformData> TransformDicList { get; set; } = new Dictionary<string, TransformData>();
	public Dictionary<string, ChapterData> ChapterDicList { get; set; } = new Dictionary<string, ChapterData>();

	private int _characterNum = 0;
	private int _sceneNum = 0;
	private int _currentChapterId = 0;
	private bool _inTransformBlock = false;
	private string _currentTransformKey = "";

	// 预编译的正则表达式，用于性能优化
	private static readonly Regex CharacterDefineRegex = new Regex(
		"define\\s+(?<key>\\w+)\\s*=\\s*Character\\(\\s*\"(?<name>.*?)\"(?:,\\s*who_color=\"(?<color>#[0-9a-fA-F]{6})\")?(?:,\\s*image=\"(?<image>.*?)\")?(?:,\\s*callback=(?<callback>\\w+))?(?:,\\s*what_suffix=\"(?<suffix>.*?)\")?(?:,\\s*cb_name='(?<cb_name>\\w+)')?\\)",
		RegexOptions.Compiled);

	private static readonly Regex ImageDefineRegex = new Regex(
		"image\\s+(?<character_key>\\w+)\\s+(?<image_emo_key>\\w+)\\s*=\\s*Image\\(\"(?<image_path>.*?)\"(?:,\\s*xanchor=(?<xanchor>[\\d.]+))?(?:,\\s*yanchor=(?<yanchor>[\\d.]+))?\\)",
		RegexOptions.Compiled);

	private static readonly Regex SceneDefineRegex = new Regex(
		"image\\s+(?<scene_key>\\w+)\\s*=\\s*\"(?<scene_path>.*?)\"",
		RegexOptions.Compiled);

	private static readonly Regex TransformStartRegex = new Regex(
		"transform\\s+(?<transform_key>\\w+):\\s*$",
		RegexOptions.Compiled);

	// 自定义数据结构来存储解析结果，避免使用Godot.Collections.Dictionary嵌套
	public class CharacterData
	{
		public string Key { get; set; }
		public string Name { get; set; }
		public Godot.Color Color { get; set; }
		public int Id { get; set; }
		public Dictionary<string, EmotionData> Img { get; set; } = new Dictionary<string, EmotionData>();
		public Rect2 ImgRect { get; set; } = new Rect2();
	}

	public class EmotionData
	{
		public string Key { get; set; }
		public string Path { get; set; }
		public Godot.Texture2D Tex { get; set; }
		public Godot.Texture2D Icon { get; set; }
		public int Id { get; set; }
	}

	public class SceneData
	{
		public string Key { get; set; }
		public string Name { get; set; }
		public string Path { get; set; }
		public Godot.Texture2D Tex { get; set; }
		public Godot.Texture2D SmallTex { get; set; }
		public int Id { get; set; }
	}

	public class TransformData
	{
		public string Key { get; set; }
		public string Name { get; set; }
		public string Type { get; set; } // "general", "scene", "character", "position", "default", "default_position"
		public Dictionary<string, float> Trans { get; set; } = new Dictionary<string, float>();
	}

	public class ChapterData
	{
		public int Id { get; set; }
		public string Key { get; set; }
		public Godot.Texture2D Img { get; set; } // 预览图
		public string Global { get; set; } = "global"; // Ren'Py 概念，可能不需要严格映射
		public List<string> JumpTo { get; set; } = new List<string>();
		public List<object> Content { get; set; } = new List<object>(); // 存储实际的脚本节点数据，或仅存储它们的字符串表示
		public Node Node { get; set; } // 章节对应的Godot节点
	}

	public override void _Ready()
	{
		// 信号初始化和其他GDScript中的_ready逻辑
		// singal_init(); // 你需要将GDScript的信号连接逻辑迁移到C#
		// transform_init(); // 这部分初始化逻辑可能也需要迁移
	}

	// GDScript: func parse_rpy_file(file_path: String)
	public void ParseRpyFile(string filePath)
	{
		if (File.Exists(filePath))
		{
			string content = File.ReadAllText(filePath);
			ProcessFileContent(content);
		}
		else
		{
			GD.PrintErr($"文件不存在: {filePath}");
		}
	}

	// GDScript: func process_file_content(content: String)
	public void ProcessFileContent(string content)
	{
		// 清空之前的数据
		CharacterDicList.Clear();
		SceneDicList.Clear();
		TransformDicList.Clear();
		ChapterDicList.Clear();
		_characterNum = 0;
		_sceneNum = 0;
		_currentChapterId = 0;
		_inTransformBlock = false;
		_currentTransformKey = "";

		// 预设默认变换（如果GDScript中InitTransformDic是硬编码的）
		// 如果 InitTransformDic 来自 @export 变量，确保它在C#脚本中也作为[Export]
		if (InitTransformDic != null)
		{
			foreach (Godot.Collections.Dictionary entry in InitTransformDic.Values)
			{
				string key = entry["1"].AsString(); // 假设 InitTransformDic 的结构是 {key: [name, key]}
				string name = entry["0"].AsString();
				TransformDicList[key] = new TransformData
				{
					Key = key,
					Name = name,
					Type = "default",
					Trans = new Dictionary<string, float>()
				};
			}
		}


		// 使用 List<string> 逐行处理更高效
		List<string> lines = new List<string>(content.Split('\n', StringSplitOptions.RemoveEmptyEntries));
		List<string> scriptLinesToProcessLater = new List<string>(); // 用于存储非定义行的脚本内容

		foreach (string rawLine in lines)
		{
			string line = rawLine.Trim();
			if (string.IsNullOrWhiteSpace(line)) continue;

			if (line.StartsWith("define character "))
			{
				ParseCharacterDefine(line);
			}
			else if (line.StartsWith("image "))
			{
				// 先尝试匹配立绘，再匹配场景
				if (ImageDefineRegex.IsMatch(line))
				{
					ParseImageDefine(line);
				}
				else if (SceneDefineRegex.IsMatch(line))
				{
					ParseSceneDefine(line); // 新增的场景解析函数
				}
			}
			else if (line.StartsWith("transform "))
			{
				SetTransformName(line);
			}
			else if (_inTransformBlock && (rawLine.StartsWith(" ") || rawLine.StartsWith("\t"))) // 判断缩进
			{
				ParseTransformDefine(line);
			}
			else if (_inTransformBlock) // 如果不在缩进块中，则结束transform块
			{
				_inTransformBlock = false; // 结束当前transform块
				// 将当前行重新处理
				scriptLinesToProcessLater.Add(rawLine);
			}
			else if (line.StartsWith("label "))
			{
				LabelAddToChapterDicList(line);
			}
			else
			{
				// 其他脚本行，先存储起来，稍后集中处理
				scriptLinesToProcessLater.Add(rawLine);
			}
		}

		// 解析完成后，初始化UI列表
		// InitCharacterList(); // 更新UI，这部分可能仍需要GDScript或C#的UI更新逻辑
		// InitSceneList();
		// InitTransList();

		// 现在处理剩下的脚本内容 (这部分属于生成节点，是你下个阶段要优化的)
		foreach (string scriptLine in scriptLinesToProcessLater)
		{
			// AddScriptItem(scriptLine); // 这部分是生成Godot UI节点，可能需要更复杂的C# Godot集成
		}

		
	}

	// GDScript: func parse_character_define(line: String)
	private void ParseCharacterDefine(string line)
	{
		Match result = CharacterDefineRegex.Match(line);
		if (result.Success)
		{
			string key = result.Groups["key"].Value;
			string name = result.Groups["name"].Value;
			string colorHex = result.Groups["color"].Success ? result.Groups["color"].Value : "#FFFFFF"; // 默认白色
			Godot.Color color = new Godot.Color(colorHex);

			CharacterData character = new CharacterData
			{
				Key = key,
				Name = name,
				Color = color,
				Id = _characterNum,
				Img = new Dictionary<string, EmotionData>(),
				ImgRect = new Rect2() // 默认值
			};

			// 添加一个默认的"none"情感，如果GDScript中NullImgDic是空的，则这里也为空
			// 如果 NullImgDic 来自 @export 变量，确保它在C#脚本中也作为[Export]
			if (NullImgDic != null && NullImgDic.ContainsKey("key") && NullImgDic.ContainsKey("path")) // 假设NullImgDic的结构是 {key: "none", path: "none"}
			{
				character.Img["none"] = new EmotionData
				{
					Key = NullImgDic["key"].AsString(),
					Path = NullImgDic["path"].AsString(),
					Tex = null, // GDScript中为null
					Icon = null, // GDScript中为null
					Id = 0
				};
			}
			else
			{
				character.Img["none"] = new EmotionData { Key = "none", Path = "none", Tex = null, Icon = null, Id = 0 };
			}


			CharacterDicList[key] = character;
			_characterNum++;

			// GDScript中的script_word_entry_map和script_shown_entry_map初始化
			// 这部分可能需要单独的Dictionary<string, List<ScriptNode>>来存储
			// ScriptWordEntryMap[key] = new List<ScriptWord>();
			// ScriptShownEntryMap[key] = new List<ScriptShown>();
		}
	}

	// GDScript: func parse_image_define(line)
	private void ParseImageDefine(string line)
	{
		Match result = ImageDefineRegex.Match(line);
		if (result.Success)
		{
			string characterKey = result.Groups["character_key"].Value;
			string emoKey = result.Groups["image_emo_key"].Value;
			string imagePath = result.Groups["image_path"].Value;

			if (CharacterDicList.TryGetValue(characterKey, out CharacterData character))
			{
				EmotionData emotion = new EmotionData
				{
					Key = emoKey,
					Path = imagePath,
					Tex = LoadImg(imagePath), // 加载实际图片
					Icon = null, // 初始为null，稍后创建缩略图
					Id = character.Img.Count // ID基于当前已有的情感数量
				};
				emotion.Icon = CreateThumbnail(emotion.Tex); // 创建缩略图

				character.Img[emoKey] = emotion;
			}
			else
			{
				GD.PrintErr($"错误: 图像 '{emoKey}' 定义了不存在的角色 '{characterKey}'");
			}
		}
	}

	// GDScript: elif scene_result: 部分的逻辑，独立为一个函数
	private void ParseSceneDefine(string line)
	{
		Match sceneResult = SceneDefineRegex.Match(line);
		if (sceneResult.Success)
		{
			string sceneKey = sceneResult.Groups["scene_key"].Value;
			string scenePath = sceneResult.Groups["scene_path"].Value;

			SceneData scene = new SceneData
			{
				Key = sceneKey,
				Name = sceneKey, // 默认名称与键值相同
				Path = scenePath,
				Id = _sceneNum
			};

			if (scenePath.StartsWith("#")) // 纯色场景
			{
				Godot.Color color = new Godot.Color(scenePath);
				scene.Tex = ColorTextureMake(color);
			}
			else // 图片场景
			{
				scene.Tex = LoadImg(scenePath);
			}
			scene.SmallTex = ReduceImg(scene.Tex, 64); // 创建小缩略图

			SceneDicList[sceneKey] = scene;
			_sceneNum++;

			// ScriptSceneEntryMap[sceneKey] = new List<ScriptScene>(); // 如果你需要跟踪场景脚本节点
		}
	}

	// GDScript: func set_transform_name(line:String)
	private void SetTransformName(string line)
	{
		Match result = TransformStartRegex.Match(line);
		if (result.Success)
		{
			_currentTransformKey = result.Groups["transform_key"].Value;
			TransformDicList[_currentTransformKey] = new TransformData
			{
				Key = _currentTransformKey,
				Name = _currentTransformKey, // 默认名称与键值相同
				Type = "general", // 默认类型
				Trans = new Dictionary<string, float>()
			};
			_inTransformBlock = true;
		}
	}

	// GDScript: func parse_transform_define(line:String)
	private void ParseTransformDefine(string line)
	{
		if (string.IsNullOrWhiteSpace(line)) return; // 忽略空行

		// Ren'Py的transform行通常是 "key value key2 value2" 或 "key value"
		// 使用更灵活的正则或分割方式
		string[] parts = line.Split(new char[] { ' ', '\t' }, StringSplitOptions.RemoveEmptyEntries);

		// 如果没有当前transform_key，则不处理
		if (string.IsNullOrEmpty(_currentTransformKey) || !TransformDicList.ContainsKey(_currentTransformKey))
		{
			GD.PrintErr("错误: 在 transform 块外部解析到变换参数.");
			_inTransformBlock = false; // 强制退出
			return;
		}

		TransformData currentTransform = TransformDicList[_currentTransformKey];

		// 识别position类型的变换
		string[] positionKeys = { "xpos", "ypos", "xanchor", "yanchor", "xalign", "yalign", "xcenter", "ycenter" };
		bool isPositionTransform = false;
		foreach (string part in parts)
		{
			if (Array.Exists(positionKeys, k => part.StartsWith(k)))
			{
				isPositionTransform = true;
				break;
			}
		}

		if (isPositionTransform && currentTransform.Type != "position")
		{
			currentTransform.Type = "position";
			// 初始化position变换的所有默认参数
			currentTransform.Trans["xpos"] = 0;
			currentTransform.Trans["ypos"] = 0;
			currentTransform.Trans["xanchor"] = 0;
			currentTransform.Trans["yanchor"] = 0;
			currentTransform.Trans["xalign"] = 0;
			currentTransform.Trans["yalign"] = 0;
			currentTransform.Trans["xcenter"] = 0;
			currentTransform.Trans["ycenter"] = 0;
			currentTransform.Trans["xzoom"] = 0; // 这些可能不是position特有的，但通常一起定义
			currentTransform.Trans["yzoom"] = 0;
			currentTransform.Trans["rotate"] = 0;
		}

		// 解析键值对
		for (int i = 0; i < parts.Length; i += 2)
		{
			if (i + 1 < parts.Length) // 确保有值
			{
				string key = parts[i];
				if (float.TryParse(parts[i + 1], out float value))
				{
					currentTransform.Trans[key] = value;
				}
				else
				{
					GD.PrintErr($"错误: 解析变换 '{_currentTransformKey}' 的参数 '{key}' 失败，值 '{parts[i + 1]}' 不是有效的浮点数。");
				}
			}
		}
	}


	// GDScript: func label_add_to_chapter_dic_list(line)
	private void LabelAddToChapterDicList(string line)
	{
		string[] parts = line.Split(' ', 2, StringSplitOptions.RemoveEmptyEntries);
		if (parts.Length < 2) return;

		string labelKey = parts[1].TrimEnd(':');
		
		ChapterData chapter = new ChapterData
		{
			Id = _currentChapterId,
			Key = labelKey,
			Img = null,
			Global = "global",
			JumpTo = new List<string>(),
			Content = new List<object>(), // 初始为空
			Node = null // 待实例化 Godot Node
		};
		_currentChapterId++;
		ChapterDicList[labelKey] = chapter;

		// LabelNodeMake(chapter); // 这部分涉及到创建Godot UI节点，可能需要特殊的Godot集成
	}

	// GDScript: func load_img(path)
	private Godot.Texture2D LoadImg(string path)
	{
		if (string.IsNullOrEmpty(path) || !File.Exists(path))
		{
			GD.PrintErr($"图片文件不存在或路径无效: {path}");
			return null;
		}

		Godot.Image image = new Godot.Image();
		Error error = image.Load(path);
		if (error != Error.Ok)
		{
			GD.PrintErr($"无法加载图片: {path}, 错误: {error}");
			return null;
		}
		Godot.ImageTexture texture = Godot.ImageTexture.CreateFromImage(image);
		return texture;
	}

	// GDScript: func create_thumbnail(imgtex:ImageTexture)
	private Godot.Texture2D CreateThumbnail(Godot.Texture2D imgtex)
	{
		if (imgtex == null || imgtex.ResourcePath == null) return null; // 检查ResourcePath是否为null，因为它是从文件加载的

		Godot.Image img = imgtex.GetImage();
		if (img == null || img.GetSize().X == 0) return null;

		// GDScript逻辑: 裁剪中间区域，并resize到60x60
		// C# Godot Image.GetRect(Rect2) 是裁剪，Image.Resize(width,height) 是缩放
		// 假设GDScript的逻辑是想裁剪一个方形区域，并缩放
		int cropSize = Math.Min(img.GetSize().X, img.GetSize().Y); // 取较小边作为裁剪边长
		int cropX = (img.GetSize().X - cropSize) / 2;
		int cropY = (img.GetSize().Y - cropSize) / 2;
		
		// 裁剪出一个方形区域
		Rect2 cropRect = new Rect2(cropX, cropY, cropSize, cropSize);
		Godot.Image croppedImg = img.GetRect(cropRect);

		// 缩放到目标大小，例如 60x60
		croppedImg.Resize(60, 60, Godot.Image.Interpolation.Bilinear);

		return Godot.ImageTexture.CreateFromImage(croppedImg);
	}
	
	// GDScript: func reduce_img(imgtex:ImageTexture,height)
	private Godot.Texture2D ReduceImg(Godot.Texture2D imgtex, int targetHeight)
	{
		if (imgtex == null || imgtex.ResourcePath == null) return null;

		Godot.Image img = imgtex.GetImage();
		if (img == null || img.GetSize().Y == 0) return null;

		int originalWidth = img.GetSize().X;
		int originalHeight = img.GetSize().Y;

		if (originalHeight == targetHeight) return imgtex; // 无需缩放

		float scale = (float)targetHeight / originalHeight;
		int newWidth = (int)(originalWidth * scale);

		Godot.Image resizedImg = img.Duplicate(); // 复制原始图像，避免修改原图
		resizedImg.Resize(newWidth, targetHeight, Godot.Image.Interpolation.Bilinear);

		return Godot.ImageTexture.CreateFromImage(resizedImg);
	}

	// GDScript: func color_texture_make(color)
	private Godot.Texture2D ColorTextureMake(Godot.Color color)
	{
		// 创建一个小的纯色图片，例如 1x1 或 64x64
		Godot.Image image = Godot.Image.Create(64, 64, false, Godot.Image.Format.Rgba8);
		image.Fill(color);
		return Godot.ImageTexture.CreateFromImage(image);
	}

	// GDScript: func get_indent_level(line: String)
	private int GetIndentLevel(string line)
	{
		int spaceCount = 0;
		int tabCount = 0;
		foreach (char ch in line)
		{
			if (ch == ' ')
			{
				spaceCount++;
			}
			else if (ch == '\t')
			{
				tabCount++;
			}
			else
			{
				break; // 遇到非空白字符停止
			}
		}
		return (spaceCount / 4) + tabCount; // 假设4个空格等于一个缩进级别
	}
	
	// // GDScript: func init_character_list():
	// private void InitCharacterList()
	// {
	// 	// 清空GDScript中的character_list (GDScript $left_panel/node_selector/characters/ScrollContainer/VBoxContainer)
	// 	// 在C#中，你需要获取对应的Godot节点并调用其ClearChildren方法（如果VBoxContainer上有这样的方法）
	// 	// 或者遍历并QueueFree()
	// 	// Example:
	// 	// var characterListVBox = GetNode<VBoxContainer>("左侧栏/节点选择器/角色/ScrollContainer/VBoxContainer");
	// 	// foreach (Node child in characterListVBox.GetChildren())
	// 	// {
	// 	//     child.QueueFree();
	// 	// }

	// 	foreach (var entry in CharacterDicList.Values)
	// 	{
	// 		// 确保 "none" 情感在有多于1个情感时被移除 (GDScript中的逻辑)
	// 		if (entry.Img.Count > 1 && entry.Img.ContainsKey("none") && entry.Img["none"].Path == "none")
	// 		{
	// 			entry.Img.Remove("none");
	// 		}
			
	// 		int emoId = 0;
	// 		foreach (var emoEntry in entry.Img.Values)
	// 		{
	// 			emoEntry.Id = emoId++;
	// 		}
	// 		// AddCharacterToList(entry); // 这涉及到UI按钮的创建和连接，需要Godot API
	// 	}
	// }

	// // GDScript: func init_scene_list():
	// private void InitSceneList()
	// {
	// 	// 清空GDScript中的scene_list
	// 	// var sceneListVBox = GetNode<VBoxContainer>("左侧栏/节点选择器/场景/ScrollContainer/VBoxContainer");
	// 	// foreach (Node child in sceneListVBox.GetChildren())
	// 	// {
	// 	//     child.QueueFree();
	// 	// }

	// 	foreach (var entry in SceneDicList.Values)
	// 	{
	// 		// AddSceneToList(entry); // 这涉及到UI按钮的创建和连接，需要Godot API
	// 	}
	// }

	// // GDScript: func init_trans_list():
	// private void InitTransList()
	// {
	// 	// 清空GDScript中的transform_list 和 position_list
	// 	// var transformListVBox = GetNode<VBoxContainer>("左侧栏/节点选择器/变换/Transform_Panel/VBoxContainer");
	// 	// var positionListVBox = GetNode<VBoxContainer>("左侧栏/节点选择器/变换/Position_Panel/VBoxContainer");
	// 	// ... (clear children)

	// 	// 重新添加初始的默认变换
	// 	// if (InitTransformDic != null)
	// 	// {
	// 	//     foreach (Godot.Collections.Dictionary entry in InitTransformDic.Values)
	// 	//     {
	// 	//         string key = entry["1"].AsString();
	// 	//         string name = entry["0"].AsString();
	// 	//         // AddTransformToList(key, name); // 这涉及到UI按钮的创建和连接
	// 	//     }
	// 	// }

	// 	// 添加解析到的变换
	// 	foreach (var entry in TransformDicList.Values)
	// 	{
	// 		// AddTransformToList(entry.Key, entry.Name); // 这涉及到UI按钮的创建和连接
	// 	}
	// }
}
