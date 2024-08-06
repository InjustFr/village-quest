extends AnimatableBody2D


class_name Npc


@export var allowed_items : Array[QuestItemResource] = []


@onready var player_detection_area : Area2D = $PlayerDetectionArea
@onready var exclamation_sprite : Sprite2D = $ExclamationSprite
@onready var interogation_sprite : Sprite2D = $InterogationSprite


const point_map : Dictionary = {
	1: 180,
	2: 100,
	3: 150
}


var player : Player = null
var waiting_on_completion : bool = false
var active : bool = false:
	set(value):
		interogation_sprite.visible = value
		active = value

func _ready() -> void:
	@warning_ignore("return_value_discarded")
	player_detection_area.body_entered.connect(_on_player_entered)
	@warning_ignore("return_value_discarded")
	player_detection_area.body_exited.connect(_on_player_exited)

	EventManager.register('PLAYER_QUEST_COMPLETED', _on_quest_completed)


func _input(event: InputEvent) -> void:
	if active and player and event.is_action_pressed("interact"):
		if not waiting_on_completion:
			_propose_quest()
			return

		if player.is_quest_complete():
			_pickup_quest()


func _on_player_entered(body: Node2D) -> void:
	if body is Player:
		player = body
		if exclamation_sprite.visible or interogation_sprite.visible:
			EventManager.trigger('CAN_INTERACT')


func _on_player_exited(body: Node2D) -> void:
	if body is Player:
		player = null
		EventManager.trigger('CAN_INTERACT_ENDED')


func _on_quest_completed(_quest: Quest) -> void:
	if waiting_on_completion:
		exclamation_sprite.visible = true


func _propose_quest() -> void:
	var quest : Quest = _generate_quest()
	player.quest = quest
	waiting_on_completion = true
	interogation_sprite.visible = false
	EventManager.trigger('CAN_INTERACT_ENDED')
	player.verify_quest()


func _pickup_quest() -> void:
	EventManager.trigger('PLAYER_QUEST_HANDED_IN', player.quest)
	SoundEffectsPlayer.play_quest_completed_sound()
	player.clear_quest()
	exclamation_sprite.visible = false
	waiting_on_completion = false
	active = false


func _generate_quest() -> Quest:
	var selected_items : Array[QuestItemResource] = []
	for i: int in 3:
		selected_items.push_back(allowed_items.pick_random())

	var quest : Quest = Quest.new()
	quest.items_asked = selected_items
	quest.points = _get_quest_points(selected_items)
	quest.name = ''

	return quest


func _get_quest_points(items: Array[QuestItemResource]) -> int:
	var nb_different_items: int = 1

	if items[0] != items[1]:
		nb_different_items += 1
	if items[1] != items[2]:
		nb_different_items += 1

	return point_map[nb_different_items]
