extends "res://scenes/player/class_modules/ClassModuleTemplate.gd"



func _ready():
	stats = {"damage" : 0.0}
	description = "Not attacking increases focus. Higher focus, higher damge. Attacking decreases focus."

func _physics_process(_delta):
	
	if user:
		if $LastAttacked.is_stopped():
			user.resource["resource"] = clamp(user.resource["resource"]+0.5, 0, user.resource["max_resource"])
			user.emit_signal("resource_changed", user.resource["resource"])
		stats["damage"] = (10.0 * (user.resource["resource"] / user.resource["max_resource"]))
			
func _on_User_primary_used():
	user.resource["resource"] = clamp(user.resource["resource"]-5, 0, user.resource["max_resource"])
	user.emit_signal("resource_changed", user.resource["resource"])
	$LastAttacked.start()
	print("last attacked starts")
