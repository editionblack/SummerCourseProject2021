extends "res://scenes/enemies/EnemyTemplate.gd"

func _ready():
	$AnimationPlayer.play("Blinking")

func move():
	var direction = Vector2(0,0)
	
	# raycast to player. If hit, the direction is set towards the player. If not, we find a direction to move towards through
	# pathfinding.
	if !is_player_in_sight():
		direction = pathfind_direction_to_player()
	else:
		path = []
		direction = (player.global_position - global_position).normalized()
	
	velocity = move_and_slide(direction * stats["movement_speed"])
