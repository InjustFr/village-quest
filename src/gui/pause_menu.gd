extends Control


@onready var continue_button : Button = $Panel/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/ContinueButton
@onready var quit_button : Button = $Panel/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/QuitButton


func _ready() -> void:
	@warning_ignore("return_value_discarded")
	continue_button.pressed.connect(_continue_playing)
	@warning_ignore("return_value_discarded")
	quit_button.pressed.connect(_quit_game)

	hide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = not get_tree().paused
		if visible:
			hide()

			return

		show()


func _continue_playing() -> void:
	get_tree().paused = false
	hide()


func _quit_game() -> void:
	get_tree().paused = false
	@warning_ignore("return_value_discarded")
	get_tree().change_scene_to_file("res://src/main_menu.tscn")
