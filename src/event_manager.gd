extends Node


var events: Dictionary = {}


func register(event: String, callback: Callable) -> void:
	if not events.has(event):
		events[event] = [callback]
		return

	@warning_ignore("unsafe_cast")
	(events[event] as Array).push_back(callback)


func trigger(event: String, data: Variant = Constants.EmptyArgument.new()) -> void:
	if not events.has(event):
		return

	for callback: Callable in events[event]:
		if not data is Constants.EmptyArgument:
			callback.call(data)

			continue

		callback.call()
