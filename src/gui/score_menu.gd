extends Panel


class_name ScoreMenu


@onready var new_game_button : Button = $CenterContainer/VBoxContainer/NewGameButton
@onready var score_label : Label = $CenterContainer/VBoxContainer/ScoreLabel


func _ready() -> void:
	@warning_ignore("return_value_discarded")
	new_game_button.pressed.connect(_on_new_game_button_pressed)


func _process(_delta: float) -> void:
	score_label.text = str(ScoreManager.score.value).pad_zeros(5)


func _on_new_game_button_pressed() -> void:
	@warning_ignore("return_value_discarded")
	get_tree().change_scene_to_file("res://src/player_name_menu.tscn")
