extends Node2D

var world
var user
var collision_mask
var stats = null
var timer = null

func _ready():
	user = get_parent()
	if stats.has("cooldown"):
		create_cooldown_timer()
	else:
		create_attackspeed_timer()

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
				timer_modifier += user.weapon.stats["weapon_attack_speed"]
			timer_modifier += user.stats["attack_speed"]
			timer.wait_time = 1.0 / timer_modifier
		"Cooldown":
			timer.wait_time = stats["cooldown"]
			#TODO: whenever/if cooldown reductions are introduced they should be calculated here


func use_ability(_direction):
	pass
