extends Node2D

var floating_number = preload("res://scenes/floating_number/FloatingNumber.tscn")

var user
var stats = {"damage" : 0.0, "heal_amount" : 100}
var description = "damaging enemies grant rage. once rage is at 100%, a hit will heal for " + str(stats["heal_amount"])

func _physics_process(_delta):
	if user:
		pass
	else:
		user = get_parent()
		if user:
			user.connect("damage_dealt", self, "_on_User_dealt_damage")
			user.connect("damage_taken", self, "_on_User_damage_taken")

func _on_User_dealt_damage(_value, _reciever):
	user.resource["resource"] = clamp(user.resource["resource"] + 20, 0, user.resource["max_resource"])
	user.emit_signal("resource_changed", user.resource["resource"])

func _on_User_damage_taken(_value, _dealer):
	if user.resource["resource"] >= user.resource["max_resource"]:
		user.stats["health"] = clamp(user.stats["health"] + stats["heal_amount"], 0, user.stats["max_health"])
		var new_floating_number = floating_number.instance()
		new_floating_number.init_floating_number(stats["heal_amount"], Color.lightgreen)
		new_floating_number.position = user.position
		user.world.call_deferred("add_child", new_floating_number)
		user.resource["resource"] = 0
		user.emit_signal("resource_changed", user.resource["resource"])
		user.emit_signal("health_changed", user.stats["health"])
		
func get_stats():
	return stats
