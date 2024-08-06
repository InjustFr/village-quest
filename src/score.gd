extends Object


class_name Score


@export var player_name: String
@export var value: int


func _init(player: String = "player", start_value: int = 0) -> void:
	player_name = player
	value = start_value
