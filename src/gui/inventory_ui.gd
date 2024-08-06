extends Control


class_name InventoryUi


class ItemInfo:
	var item: QuestItemResource
	var amount: int

	func _init(i: QuestItemResource, a: int) -> void:
		item = i
		amount = a


@onready var item_scene: PackedScene = preload("res://src/gui/inventory_element_ui.tscn")


func _init() -> void:
	EventManager.register('INVENTORY_UPDATED', _on_inventory_updated)


func _on_inventory_updated(inventory: Array[QuestItemResource]) -> void:
	_clear_children()
	var compacted_inventory: Array[ItemInfo] = _build_compact_array(inventory)
	_build_ui(compacted_inventory)


func _clear_children() -> void:
	for child: Control in get_children():
		remove_child(child)


func _build_compact_array(inventory: Array[QuestItemResource]) -> Array[ItemInfo]:
	var result : Dictionary = {}

	for item : QuestItemResource in inventory:
		if result.has(item.type):
			@warning_ignore("unsafe_cast")
			(result[item.type] as ItemInfo).amount += 1
			continue

		result[item.type] = ItemInfo.new(item, 1)

	var array_result : Array[ItemInfo] = []
	for r: ItemInfo in result.values():
		array_result.push_back(r)

	return array_result


func _build_ui(inventory: Array[ItemInfo]) -> void:
	for i : ItemInfo in inventory:
		var scene : InventoryElementUi = item_scene.instantiate()
		scene.label = i.item.name
		scene.icon_path = i.item.icon_path
		scene.icon_atlas = i.item.icon_atlas
		scene.atlas_pos = i.item.atlas_pos
		scene.amount = i.amount

		add_child(scene)
