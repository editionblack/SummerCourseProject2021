extends Node2D

var world
var user
var collision_mask
var stats = null
var timer = null
var ability_used_signal = ""

func _ready():
	user = get_parent()
	if stats.has("cooldown"):
		create_cooldown_timer()
		ability_used_signal = "secondary_used"
	else:
		create_attackspeed_timer()
		ability_used_signal = "primary_used"

func create_cooldown_timer():
	var cooldown_timer = Timer.new()
	cooldown_timer.name = "Cooldown"
	cooldown_timer.autostart = false
	cooldown_timer.one_shot = true
	cooldown_timer.wait_time = stats["cooldown"]
	timer = cooldown_timer
	add_child(cooldown_timer)

func create_attackspeed_timer():
	var attackspeed_timer = Timer.new()
	attackspeed_timer.name = "AttackSpeed"
	attackspeed_timer.autostart = false
	attackspeed_timer.one_shot = true
	timer = attackspeed_timer
	add_child(attackspeed_timer)

func update_timer():
	var timer_modifier = 0
	
	match timer.name:
		"AttackSpeed":
			if user.weapon:
				timer_modifier = DamageCalculationHandler.get_attack_speed(user, user.weapon.stats["weapon_attack_speed"])
			else:
				timer_modifier = DamageCalculationHandler.get_attack_speed(user, stats["base_attack_speed"])
			
			timer.wait_time = 1.0 / timer_modifier
		"Cooldown":
			timer_modifier = stats["cooldown"]
			if user.stats.has("cooldown_reduction"):
				timer_modifier *= (1.0 - (user.stats["cooldown_reduction"] / 100.0))
			if timer_modifier <= 0:
				timer_modifier = 0.001 # since the timer can't be set to 0 seconds we set it to the lowest possible value instead.
			timer.wait_time = timer_modifier

func ability_used():
	user.emit_signal(ability_used_signal)

func use_ability(_direction):
	pass
