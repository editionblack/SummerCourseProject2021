extends "res://scenes/abilities/AbilityTemplate.gd"

func _ready():
	._ready()
	$Cooldown.wait_time = stats["cooldown"]

func use_ability(_direction):
	if !$Cooldown.is_stopped():
		return
	user.stats["health"] = clamp(user.stats["health"] + stats["heal_amount"], 0, user.stats["max_health"])
	$Cooldown.start()
