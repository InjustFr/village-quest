extends Node


var scores : Array[Score] = []
var score : Score


func _init() -> void:
	_check_score_file()
	_load_scores()


func _check_score_file() -> void:
	if not FileAccess.file_exists("user://scores.dat"):
		scores = [
			Score.new("Nathan", 1000),
			Score.new("Iris", 750),
			Score.new("Nicole", 500),
			Score.new("John", 250),
			Score.new("Artemis", 100)
		]
		_save_scores()


func _load_scores() -> void:
	var file : FileAccess = FileAccess.open("user://scores.dat", FileAccess.READ)
	scores = file.get_var(true)


func _save_scores() -> void:
	var file : FileAccess = FileAccess.open("user://scores.dat", FileAccess.WRITE)
	file.store_var(scores, true)


func _ready() -> void:
	EventManager.register('PLAYER_QUEST_HANDED_IN', _on_quest_handed_in)
	EventManager.register('GAME_TIMER_STOPPED', _on_game_timer_stopped)

	score = Score.new("", 0)


func _on_quest_handed_in(quest: Quest) -> void:
	for i: QuestItemResource in quest.items_asked:
		score.value += i.points

	score.value += quest.points


func _on_game_timer_stopped(_timer_node: Timer) -> void:
	for i : int in scores.size():
		if scores[i].value < score.value:
			@warning_ignore("return_value_discarded")
			scores.insert(i, score)
			break


func _exit_tree() -> void:
	_save_scores()
