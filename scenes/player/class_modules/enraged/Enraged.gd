extends "res://scenes/player/class_modules/ClassModuleTemplate.gd"

var floating_number = preload("res://scenes/floating_number/FloatingNumber.tscn")

func _ready():
	stats = {"damage" : 0.0, "heal_amount" : 100, "rage_per_hit" : 10}
	description = "Hits grant rage.\nTaking damage at 50% health and 100% rage heals for " + str(stats["heal_amount"]) + " health."
	
func _on_User_dealt_damage(_value, _reciever, _is_critical):
	user.resource["resource"] = clamp(user.resource["resource"] + stats["rage_per_hit"], 0, user.resource["max_resource"])
	user.emit_signal("resource_changed", user.resource["resource"])

func _on_User_damage_taken(value, _dealer, _is_critical):
	if user.resource["resource"] >= user.resource["max_resource"] and user.stats["health"] + value <= user.stats["max_health"] / 2:
		user.stats["health"] = clamp(user.stats["health"] + stats["heal_amount"], 0, user.stats["max_health"])
		var new_floating_number = floating_number.instance()
		new_floating_number.init_floating_number(stats["heal_amount"], Color.lightgreen, Vector2(1.25, 1.25))
		new_floating_number.position = user.position
		user.world.call_deferred("add_child", new_floating_number)
		user.resource["resource"] = 0
		user.emit_signal("resource_changed", user.resource["resource"])
		user.emit_signal("health_changed", user.stats["health"])
