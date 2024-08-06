extends Label


func _process(_delta: float) -> void:
	text = str(ScoreManager.score.value).pad_zeros(5)
