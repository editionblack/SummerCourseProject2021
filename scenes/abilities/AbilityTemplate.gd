extends Node2D

var world
var user
var collision_mask
var stats = null

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
	add_child(cooldown_timer)

func create_attackspeed_timer():
	var attackspeed_timer = Timer.new()
	attackspeed_timer.name = "AttackSpeed"
	attackspeed_timer.autostart = false
	attackspeed_timer.one_shot = true
	attackspeed_timer.wait_time = 1.0 / user.stats["attack_speed"]
	add_child(attackspeed_timer)

func use_ability(_direction):
	pass
