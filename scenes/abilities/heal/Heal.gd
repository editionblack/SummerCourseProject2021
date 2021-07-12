extends "res://scenes/abilities/AbilityTemplate.gd"

func use_ability(_direction):
	if !$Cooldown.is_stopped():
		return
	user.stats["health"] = clamp(user.stats["health"] + stats["heal_amount"], 0, user.stats["max_health"])
	user.emit_signal("health_changed", user.stats["health"])
	$Cooldown.start()
