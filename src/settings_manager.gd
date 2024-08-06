extends Node


@export var settings: Dictionary = {
	fullscreen =  true,
	vsync = true,
	music_level = -6,
	sound_effects_level = 0
}


func _ready() -> void:
	_load_settings()

	call_deferred("_setup_game")


func _setup_game() -> void:
	@warning_ignore("unsafe_call_argument")
	set_fullscreen(settings["fullscreen"])
	@warning_ignore("unsafe_call_argument")
	set_vsync(settings["vsync"])
	@warning_ignore("unsafe_call_argument")
	set_music_level(settings["music_level"])
	@warning_ignore("unsafe_call_argument")
	set_sound_effects_level(settings["sound_effects_level"])


func _load_settings() -> void:
	if not FileAccess.file_exists("user://settings.dat"):
		save_settings()

	var file : FileAccess = FileAccess.open("user://settings.dat", FileAccess.READ)
	settings = file.get_var(true)


func save_settings() -> void:
	var file : FileAccess = FileAccess.open("user://settings.dat", FileAccess.WRITE)
	file.store_var(settings, true)


func _exit_tree() -> void:
	save_settings()


func set_fullscreen(fullscreen: bool) -> void:
	settings["fullscreen"] = fullscreen
	if fullscreen:
		get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN
		return

	get_window().mode = Window.MODE_WINDOWED
	get_window().borderless = false
	get_window().size = _get_closest_size(DisplayServer.screen_get_size() / 2)
	_center_window()


func _center_window() -> void:
	var center_screen : Vector2i = DisplayServer.screen_get_position() + DisplayServer.screen_get_size() / 2
	var window_size : Vector2i = get_window().get_size_with_decorations()
	get_window().set_position(center_screen - window_size / 2)


func _get_closest_size(target_size: Vector2i) -> Vector2i:
	@warning_ignore("unsafe_call_argument")
	var viewport_size: Vector2i = Vector2i(
		int(ProjectSettings.get_setting("display/window/size/viewport_width")),
		int(ProjectSettings.get_setting("display/window/size/viewport_height"))
	)

	@warning_ignore("integer_division")
	var multiplier: int = target_size.x / viewport_size.x
	return viewport_size * multiplier


func set_vsync(vsync: bool) -> void:
	settings["vsync"] = vsync
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if vsync else DisplayServer.VSYNC_DISABLED)


func set_music_level(level: float) -> void:
	settings["music_level"] = level
	MusicPlayer.volume_db = level


func set_sound_effects_level(level: float) -> void:
	settings["sound_effects_level"] = level
	SoundEffectsPlayer.volume_db = level
