extends AudioStreamPlayer2D

func _on_Sound_finished():
	queue_free()

