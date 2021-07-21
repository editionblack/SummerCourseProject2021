extends "res://scenes/enemies/EnemyTemplate.gd"

var ability

func _ready():
	ability = AbilityHandler.get_ability("shoot_projectile", 1+2)
	call_deferred("add_child", ability)

func attack():
	if is_player_in_sight() and distance_to_player() < 500:
		ability.use_ability((player.global_position - global_position).normalized().rotated(deg2rad(randi() % 21 - 10)))

func move():
	var direction = Vector2()
	if !is_player_in_sight() or distance_to_player() > 300:
		direction = pathfind_direction_to_player()
	else:
		if distance_to_player() < 280:
			direction = (player.global_position - global_position).normalized() * -1
	velocity = move_and_slide(direction * stats["movement_speed"])


