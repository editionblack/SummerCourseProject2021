extends Node2D

var user

func _physics_process(_delta):
	if user:
		user.resource["resource"] += 0.1
		user.resource["resource"] = clamp(user.resource["resource"], 0, user.resource["max_resource"])
		user.emit_signal("resource_changed", user.resource["resource"])
	else:
		user = get_parent()

