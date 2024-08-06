extends Resource


class_name Quest


@export var name : String
@export var points : int
@export var items_asked : Array[QuestItemResource] = []


func is_complete(items: Array[QuestItemResource]) -> bool:
	return missing_items(items) == []


func missing_items(items: Array[QuestItemResource]) -> Array[QuestItemResource]:
	var temp : Array[QuestItemResource] = items_asked.duplicate()
	for item: QuestItemResource in items:
		var pos: int = temp.find(item)
		if pos != -1:
			temp.remove_at(pos)

	return temp
