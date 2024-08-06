extends Control


@onready var timer_node : Timer = $Timer
@onready var score_menu : ScoreMenu = $ScoreMenu


func _ready() -> void:
	@warning_ignore("return_value_discarded")
	timer_node.timeout.connect(_on_timer_ended)

	EventManager.register('PLAYER_QUEST_HANDED_IN', _on_quest_completed)

	MusicPlayer.play_game_music()
	_start_game()


func _on_timer_ended() -> void:
	get_tree().paused = true
	score_menu.visible = true
	SoundEffectsPlayer.play_game_over_sound()
	MusicPlayer.play_menu_music()
	EventManager.trigger('GAME_TIMER_STOPPED', timer_node)


func _start_game() -> void:
	_activate_npc()
	timer_node.start()
	MusicPlayer.play_game_music()
	EventManager.trigger('GAME_TIMER_STARTED', timer_node)
	get_tree().paused = false
	score_menu.visible = false


func _activate_npc() -> void:
	var npcs : Array[Node] = get_tree().get_nodes_in_group("npcs")
	var npc : Npc = npcs.pick_random()
	while npc.active:
		npc = npcs.pick_random()

	npc.active = true


func _on_quest_completed(_quest: Quest) -> void:
	_activate_npc()
