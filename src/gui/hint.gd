extends MarginContainer


@onready var hint_text : Label = $HBoxContainer/HintText


func _ready() -> void:
	EventManager.register('CAN_INTERACT', _show_interact_hint)
	EventManager.register('CAN_COLLECT', _show_collect_hint)
	EventManager.register('CAN_COLLECT_ENDED', _hide_hint)
	EventManager.register('CAN_INTERACT_ENDED', _hide_hint)


func _hide_hint() -> void:
	visible = false


func _show_collect_hint() -> void:
	hint_text.text = "COLLECT"
	visible = true


func _show_interact_hint() -> void:
	hint_text.text = "INTERACT"
	visible = true
