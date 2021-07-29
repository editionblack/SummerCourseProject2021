extends "res://scenes/abilities/AbilityTemplate.gd"

var floating_number = preload("res://scenes/floating_number/FloatingNumber.tscn")
onready var heal_particles = $HealParticles

func _ready():
	$HealParticles.emitting = false
	$HealParticles.one_shot = true

func use_ability(_direction):
	if !$Cooldown.is_stopped():
		return
	var previous_user_health = user.stats["health"]
	var healing_power = DamageCalculationHandler.calculate_secondary_damage(user, stats)
	user.stats["health"] = clamp(previous_user_health + healing_power, 0, user.stats["max_health"])
	var new_floating_number = floating_number.instance()
	new_floating_number.init_floating_number(user.stats["health"] - previous_user_health, Color.lightgreen)
	new_floating_number.position = user.position
	$HealParticles.emitting = true
	world.call_deferred("add_child", new_floating_number)
	user.emit_signal("health_changed", user.stats["health"])
	
	update_timer()
	ability_used()
	$Cooldown.start()
