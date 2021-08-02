extends Node

signal level_changed(new_value)
# might not be best practice but i am going to, for now, keep global variables here
var scaling = 1.0
var level = 1

func increase_scaling(value : float):
	level += 1
	scaling += value
	emit_signal("level_changed", level)

func reset_scaling():
	level = 1
	scaling = 1.0
	emit_signal("level_changed", level)

func set_scaling(value : float):
	scaling = value

func get_scaling():
	return scaling

func get_level():
	return level
