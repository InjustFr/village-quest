extends Area2D


class_name QuestItemSpawner


@export var item: PackedScene
@export var cooldown: float = 1
@export var spawn_radius: int = 32

@onready var timer: Timer = $Timer

var interactable: bool = false


func _ready() -> void:
	@warning_ignore("return_value_discarded")
	body_entered.connect(_enable_spawner)
	@warning_ignore("return_value_discarded")
	body_exited.connect(_disable_spawner)
	timer.wait_time = cooldown
	@warning_ignore("return_value_discarded")
	timer.timeout.connect(_spawn_item)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed('interact') && interactable && timer.time_left == 0:
		_start_spawning()


func _start_spawning() -> void:
	EventManager.trigger('COLLECTION_STARTED')
	timer.start()


func _spawn_item() -> void:
	var r : float = sqrt(randf_range(0.0, 1.0)) * spawn_radius
	var t : float= randf_range(0.0, 1.0) * TAU
	var offset : Vector2 = Vector2(r * cos(t), r * sin(t))
	var spawn_pos : Vector2 = global_position + offset

	var instance : Node2D = item.instantiate()
	get_parent().add_child(instance)
	instance.global_position = spawn_pos

	EventManager.trigger('COLLECTION_ENDED')


func _enable_spawner(body: Node2D) -> void:
	if body is Player:
		interactable = true
		EventManager.trigger('CAN_COLLECT')


func _disable_spawner(body: Node2D) -> void:
	if body is Player:
		interactable = false
		EventManager.trigger('CAN_COLLECT_ENDED')
