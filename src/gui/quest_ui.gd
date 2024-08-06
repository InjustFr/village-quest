extends VBoxContainer


class_name QuestUI


@onready var item_scene : PackedScene = preload("res://src/gui/quest_item_ui.tscn")
@onready var name_node : Label = $HBoxContainer/NameLabel
@onready var quest_items_container : VBoxContainer = $QuestItemsContainer
@onready var complete_label : Label = $HBoxContainer/Panel/CompleteLabel


func _init() -> void:
	EventManager.register('PLAYER_QUEST_CHANGED', _on_player_quest_updated)
	EventManager.register('PLAYER_QUEST_COMPLETED', _on_player_quest_completed)


func _on_player_quest_updated(quest: Quest) -> void:
	if not quest:
		visible = false
		return

	visible = true
	complete_label.visible = false

	_build_ui(quest)


func _on_player_quest_completed(_quest: Quest) -> void:
	complete_label.visible = true


func _build_ui(quest: Quest) -> void:
	for n : Node in quest_items_container.get_children():
		quest_items_container.remove_child(n)

	for i: QuestItemResource in quest.items_asked:
		var scene : QuestItemUi = item_scene.instantiate()
		scene.label = i.name
		scene.icon_path = i.icon_path
		scene.icon_atlas = i.icon_atlas
		scene.atlas_pos = i.atlas_pos
		quest_items_container.add_child(scene)
