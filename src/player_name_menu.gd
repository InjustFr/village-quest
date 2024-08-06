extends Control


class_name PlayerNameMenu


@onready var start_button : Button = $MarginContainer/VBoxContainer/HBoxContainer/StartButton
@onready var back_button : Button = $MarginContainer/VBoxContainer/HBoxContainer/BackButton
@onready var player_name_edit : LineEdit = $MarginContainer/VBoxContainer/PlayerNameEdit


func _ready() -> void:
	@warning_ignore("return_value_discarded")
	start_button.pressed.connect(_start_game)
	@warning_ignore("return_value_discarded")
	back_button.pressed.connect(_return_to_menu)

	@warning_ignore("return_value_discarded")
	player_name_edit.text_changed.connect(_to_uppercase)


func _start_game() -> void:
	ScoreManager.score.player_name = player_name_edit.text
	@warning_ignore("return_value_discarded")
	get_tree().change_scene_to_file("res://src/game.tscn")


func _to_uppercase(new_text : String) -> void:
	player_name_edit.text = new_text.to_upper()
	player_name_edit.caret_column = new_text.length()


func _return_to_menu() -> void:
	SettingsManager.save_settings()
	@warning_ignore("return_value_discarded")
	get_tree().change_scene_to_file("res://src/main_menu.tscn")
