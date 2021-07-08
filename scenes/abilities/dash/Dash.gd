extends "res://scenes/abilities/AbilityTemplate.gd"

var in_use = false

func _ready():
	._ready()
	$Cooldown.wait_time = stats["cooldown"]

func use_ability(_direction):
	if !$Cooldown.is_stopped() or in_use:
		return
		
	in_use = true
	user.can_move = false
	var speed = 1200
	while speed > 100:
		user.velocity = user.velocity.normalized() * speed
		speed /= 2
		yield(get_tree().create_timer(0.1),"timeout")
	user.can_move = true
	in_use = false
	
	$Cooldown.start()
