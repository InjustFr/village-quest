extends CharacterBody2D


class_name Player


@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var smoke_sprite : AnimatedSprite2D = $SmokeSprite


@export var speed : int = 76
var old_velocity : Vector2 = Vector2.ZERO
var quest : Quest = null :
	set (value):
		quest = value
		EventManager.trigger('PLAYER_QUEST_CHANGED', quest)

var inventory: Array[QuestItemResource]
var collecting: bool = false


func _ready() -> void:
	sprite.play("idle_down")
	smoke_sprite.visible = false
	EventManager.register('COLLECTION_STARTED', _start_smoke_animation)
	EventManager.register('COLLECTION_ENDED', _end_smoke_animation)


func _start_smoke_animation() -> void:
	smoke_sprite.frame = 0
	smoke_sprite.play("default")
	smoke_sprite.visible = true
	collecting = true
	SoundEffectsPlayer.play_collect_sound()


func _end_smoke_animation() -> void:
	smoke_sprite.visible = false
	smoke_sprite.stop()
	collecting = false
	SoundEffectsPlayer.stop_collect_sound()


func _physics_process(_delta: float) -> void:
	var direction : Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if direction and not collecting:
		velocity = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)

	if velocity != Vector2.ZERO:
		sprite.play("walk_" + _get_orientation(velocity))
		old_velocity = velocity;

	if velocity == Vector2.ZERO && old_velocity:
		sprite.play("idle_" + _get_orientation(old_velocity))

	@warning_ignore("return_value_discarded")
	move_and_slide()


func _get_orientation(vec: Vector2) -> String:
	if vec.y > 0 and vec.x == 0:
		return "down"
	if vec.y < 0 and vec.x == 0:
		return "up"
	if vec.x > 0:
		return "right"
	if vec.x < 0:
		return "left"
	return ""


func add_item(item: QuestItemResource) -> void:
	inventory.push_back(item)
	EventManager.trigger('INVENTORY_UPDATED', inventory)
	verify_quest()


func verify_quest() -> void:
	if is_quest_complete():
		EventManager.trigger('PLAYER_QUEST_COMPLETED', quest)


func is_quest_complete() -> bool:
	if not quest:
		return false

	return quest.is_complete(inventory)

func clear_quest() -> void:
	if is_quest_complete():
		for item: QuestItemResource in quest.items_asked:
			var pos: int = inventory.find(item)
			if pos != -1:
				inventory.remove_at(pos)

	EventManager.trigger('INVENTORY_UPDATED', inventory)
	quest = null
