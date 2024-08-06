extends Control


@onready var fullscreen_box : CheckBox = $MarginContainer/VBoxContainer/ScrollContainer/MarginContainer/VBoxContainer/FullscreenContainer/CheckBox
@onready var vsync_box : CheckBox = $MarginContainer/VBoxContainer/ScrollContainer/MarginContainer/VBoxContainer/VSyncContainer/CheckBox
@onready var music_level_range : HSlider = $MarginContainer/VBoxContainer/ScrollContainer/MarginContainer/VBoxContainer/MusicLevelContainer/HSlider
@onready var sound_effects_level_range : HSlider = $MarginContainer/VBoxContainer/ScrollContainer/MarginContainer/VBoxContainer/SoundEffectsLevelContainer/HSlider

@onready var ok_button : Button = $MarginContainer/VBoxContainer/MarginContainer/OkButton


func _ready() -> void:
	fullscreen_box.button_pressed = SettingsManager.settings["fullscreen"]
	@warning_ignore("return_value_discarded")
	fullscreen_box.toggled.connect(_change_fullscreen)

	vsync_box.button_pressed = SettingsManager.settings["vsync"]
	@warning_ignore("return_value_discarded")
	vsync_box.toggled.connect(_change_vsync)

	@warning_ignore("unsafe_call_argument")
	music_level_range.value = db_to_linear(SettingsManager.settings["music_level"] + 6) * 10
	@warning_ignore("return_value_discarded")
	music_level_range.value_changed.connect(_change_music_level)

	@warning_ignore("unsafe_call_argument")
	sound_effects_level_range.value = db_to_linear(SettingsManager.settings["sound_effects_level"]) * 10
	@warning_ignore("return_value_discarded")
	sound_effects_level_range.value_changed.connect(_change_sound_effects_level)

	@warning_ignore("return_value_discarded")
	ok_button.pressed.connect(_return_to_menu)


func _change_fullscreen(toggled_on: bool) -> void:
	SettingsManager.set_fullscreen(toggled_on)


func _change_vsync(toggled_on: bool) -> void:
	SettingsManager.set_vsync(toggled_on)


func _change_music_level(value: int) -> void:
	SettingsManager.set_music_level(linear_to_db(float(value)/10) - 6)


func _change_sound_effects_level(value: int) -> void:
	SettingsManager.set_sound_effects_level(linear_to_db(float(value)/10))
	SoundEffectsPlayer.play_item_collected_sound()


func _return_to_menu() -> void:
	SettingsManager.save_settings()
	@warning_ignore("return_value_discarded")
	get_tree().change_scene_to_file("res://src/main_menu.tscn")
