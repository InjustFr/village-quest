extends Control


class_name MainMenu


const score_line_length : int = 20

@onready var name_labels : Array[Label] = [
	$MarginContainer/VBoxContainer/HighScores/ScoreContainer1/Name,
	$MarginContainer/VBoxContainer/HighScores/ScoreContainer2/Name,
	$MarginContainer/VBoxContainer/HighScores/ScoreContainer3/Name,
	$MarginContainer/VBoxContainer/HighScores/ScoreContainer4/Name,
	$MarginContainer/VBoxContainer/HighScores/ScoreContainer5/Name,
]

@onready var score_labels : Array[Label] = [
	$MarginContainer/VBoxContainer/HighScores/ScoreContainer1/Score,
	$MarginContainer/VBoxContainer/HighScores/ScoreContainer2/Score,
	$MarginContainer/VBoxContainer/HighScores/ScoreContainer3/Score,
	$MarginContainer/VBoxContainer/HighScores/ScoreContainer4/Score,
	$MarginContainer/VBoxContainer/HighScores/ScoreContainer5/Score,
]
@onready var new_game_button : Button = $MarginContainer/VBoxContainer/HBoxContainer/NewGameButton
@onready var options_button : Button = $MarginContainer/VBoxContainer/HBoxContainer/OptionsButton
@onready var quit_button : Button = $MarginContainer/VBoxContainer/HBoxContainer/QuitButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_display_scores()

	@warning_ignore("return_value_discarded")
	new_game_button.pressed.connect(_switch_scene)
	@warning_ignore("return_value_discarded")
	options_button.pressed.connect(_switch_to_options_scene)
	@warning_ignore("return_value_discarded")
	quit_button.pressed.connect(_quit_game)


	if not MusicPlayer.playing:
		MusicPlayer.play_menu_music()


func _display_scores() -> void:
	for i : int in score_labels.size():
		var score : Score = ScoreManager.scores[i]
		name_labels[i].text = score.player_name
		score_labels[i].text = str(score.value)


func _switch_scene() -> void:
	@warning_ignore("return_value_discarded")
	get_tree().change_scene_to_file("res://src/player_name_menu.tscn")


func _switch_to_options_scene() -> void:
	@warning_ignore("return_value_discarded")
	get_tree().change_scene_to_file("res://src/options_menu.tscn")


func _quit_game() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
