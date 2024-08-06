extends AudioStreamPlayer


func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS


func play_menu_music() -> void:
	stream = load("res://assets/1 - Adventure Begin.ogg")
	play()


func play_game_music() -> void:
	stream = load("res://assets/4 - Village.ogg")
	play()
