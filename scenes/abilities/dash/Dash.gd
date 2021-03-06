extends "res://scenes/abilities/AbilityTemplate.gd"

var in_use = false
onready var dash_sound = $DashSound

func use_ability(_direction):
	if !$Cooldown.is_stopped() or in_use:
		return
	dash_sound.play()
	in_use = true
	user.can_move = false
	var speed = 1200
	while speed > 150:
		user.velocity = user.last_direction * speed
		speed /= 2
		yield(get_tree().create_timer(0.1),"timeout")
	user.can_move = true
	in_use = false
	
	$Cooldown.start()
