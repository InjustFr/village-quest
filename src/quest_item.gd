extends StaticBody2D


class_name QuestItem


@onready var collect_area: Area2D = $CollectArea
@export var type : Constants.QuestItemType
@export var speed : float = 56
@export var item: QuestItemResource


var target : Player = null

func _ready() -> void:
	@warning_ignore("return_value_discarded")
	collect_area.body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		target = (body as Player)


func _physics_process(delta: float) -> void:
	if target:
		global_position = global_position.move_toward(target.global_position, delta * speed)

		if global_position.distance_to(target.global_position) < 4:
			target.add_item(item)
			SoundEffectsPlayer.play_item_collected_sound()
			queue_free()
