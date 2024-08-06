extends Label


var timer : Timer


func _ready() -> void:
	EventManager.register('GAME_TIMER_STARTED', _link_timer)


func _process(_delta: float) -> void:
	if timer:
		var current_time : int = int(timer.time_left)
		@warning_ignore("integer_division")
		var minutes : int = current_time / 60
		var seconds : int = current_time - 60 * minutes

		text = str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2)


func _link_timer(t: Timer) -> void:
	timer = t
