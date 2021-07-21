extends "res://scenes/enemies/EnemyTemplate.gd"

var rotation_speed = 5.0
var min_rotation_speed = 5.0
var max_rotation_speed = 20.0

func _ready():
	$DamageTimer.wait_time = stats["damage_frequency"]

func attack():
	if global_position.distance_to(world.get_player().global_position) < 150:
		rotation_speed = lerp(rotation_speed, max_rotation_speed, 0.25)
	else:
		rotation_speed = lerp(rotation_speed, min_rotation_speed, 0.25)

func move():
	var player = world.player
	var direction = Vector2(0,0)
	
	# raycast to player. If hit, the direction is set towards the player. If not, we find a direction to move towards through
	# pathfinding.
	if !is_player_in_sight():
		direction = pathfind_direction_to_player()
	else:
		path = []
		direction = (player.global_position - global_position).normalized()
	
	velocity = move_and_slide(direction * stats["movement_speed"])

func _physics_process(delta):
	if !is_stunned:
		$Sprite.rotation += rotation_speed * delta

func _on_Hurtbox_body_entered(body):
	targets.append(body)
	$DamageTimer.start()

func _on_Hurtbox_body_exited(body):
	targets.erase(body)
	if targets.size() < 1:
		$DamageTimer.stop()

func _on_DamageTimer_timeout():
	if !is_stunned:
		for target in targets:
			target.on_hit(stats["damage"], self)
