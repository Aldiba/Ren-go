extends Button
@onready var audio_player= %AudioStreamPlayer
@onready var animation_timer = $Timer
var is_playing: bool = false
var anim_chars: PackedStringArray = ["🔈", "🔉", "🔊"]
var current_char_index: int = 0


func _ready() -> void:
	# Connect the button's pressed signal
	pressed.connect(_on_MusicButton_pressed)

	# Setup the animation timer
	#animation_timer = Timer.new()
	#add_child(animation_timer)
	#animation_timer.wait_time = 0.2 # Adjust this for animation speed
	#animation_timer.timeout.connect(_on_animation_timer_timeout)
	#animation_timer.one_shot = false

	# Load the audio stream if sound_path is set
	if not $"../..".sound_path.is_empty():
		load_audio_stream($"../..".sound_path)

func load_audio_stream(path) -> void:
	if not path.is_empty():
		var stream: AudioStream = AudioStreamWAV.load_from_file(path)
		if stream:
			audio_player.set_stream(stream)
			print("Loaded audio stream from path: ", path)
			disabled = false
			
		else:
			print_debug("Failed to load audio stream from path: ", path)
			disabled = true

func _on_MusicButton_pressed() -> void:
	if is_playing:
		stop_music()
	else:
		play_music()

func play_music() -> void:
	if audio_player.get_stream():
		audio_player.play()
		is_playing = true
		animation_timer.start()
		#text = anim_chars[current_char_index] # Set initial character
		audio_player.finished.connect(_on_audio_player_finished) # Connect finished signal
	else:
		print_debug("No audio stream assigned to AudioPlayer.")

func stop_music() -> void:
	audio_player.stop()
	is_playing = false
	animation_timer.stop()
	text = "🔈" # Reset character
	audio_player.finished.disconnect(_on_audio_player_finished) # Disconnect to prevent multiple connections

func _on_animation_timer_timeout() -> void:
	if is_playing:
		current_char_index = (current_char_index + 1) % anim_chars.size()
		text = anim_chars[current_char_index]

func _on_audio_player_finished() -> void:
	stop_music() # Music finished playing naturally


func _on_audio路径选择窗口_file_selected(path: String) -> void:
	load_audio_stream(path)
	tooltip_text = path.get_file()
