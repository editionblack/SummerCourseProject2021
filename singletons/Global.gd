extends Node

signal scaling_changed(new_value)
# might not be best practice but i am going to, for now, keep global variables here
var scaling = 1.0

func increase_scaling(value : float):
	scaling += value
	emit_signal("scaling_changed", scaling)

func reset_scaling():
	scaling = 1.0
	emit_signal("scaling_changed", scaling)

func get_scaling():
	return scaling
