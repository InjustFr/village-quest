extends AudioStreamPlayer


@onready var collect_sound : AudioStream = preload("res://assets/Hit.wav")
@onready var item_collected_sound : AudioStream = preload("res://assets/Gold1.wav")
@onready var quest_complete_sound : AudioStream = preload("res://assets/Success1.wav")
@onready var game_over_sound : AudioStream = preload("res://assets/GameOver.wav")


func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS


func play_item_collected_sound() -> void:
	stream = item_collected_sound
	play()


func play_quest_completed_sound() -> void:
	stream = quest_complete_sound
	play()


func play_game_over_sound() -> void:
	stream = game_over_sound
	play()


func play_collect_sound() -> void:
	stream = collect_sound
	@warning_ignore("return_value_discarded")
	finished.connect(collect_sound_callback)
	play()


func stop_collect_sound() -> void:
	@warning_ignore("return_value_discarded")
	finished.disconnect(collect_sound_callback)


func collect_sound_callback() -> void:
	await get_tree().create_timer(0.2).timeout
	play()
