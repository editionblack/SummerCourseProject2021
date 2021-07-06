extends "res://scenes/enemies/EnemyTemplate.gd"

var rotation_speed = 5.0
var min_rotation_speed = 5.0
var max_rotation_speed = 20.0

func _ready():
	._ready()
	$DamageTimer.wait_time = stats["damage_frequency"]

func attack():
	if global_position.distance_to(world.get_player().global_position) < 150:
		rotation_speed = lerp(rotation_speed, max_rotation_speed, 0.25)
	else:
		rotation_speed = lerp(rotation_speed, min_rotation_speed, 0.25)

func move():
	var player = world.get_player()
	var direction = Vector2(0,0)
	
	# raycast to the player position and get the first thing that the raycast collides with
	$RayCast2D.cast_to = player.global_position - global_position
	$RayCast2D.force_raycast_update()
	var raycast_collision = $RayCast2D.get_collider()
	
	# if the raycast cant directly hit the player we use the navigation2d node to get a simple path
	# that the enemy will try to follow instead. if no path to the player is possible we simply remove
	# the enemy for the time being as this would indicate that the enemey has been spawned somewhere
	# it shouldn't have. If a path is available the enemy will move towards the first position in the array
	# until its close enough that the position should be removed.
	# if the raycast does hit the player the enemy just moves straight towards it.
	if raycast_collision != player:
		if path.size() < 1:
			path = nav2d.get_simple_path(global_position, player.global_position, false)
			if path.size() < 1:
				queue_free()
				return
		if global_position.distance_to(path[0]) < 1:
			path.remove(0)
		else:
			direction = (path[0] - global_position).normalized()
	else:
		path = []
		direction = (player.global_position - global_position).normalized()
	
	velocity = move_and_slide(direction * stats["movement_speed"])

func _physics_process(delta):
	if !is_stunned:
		$Sprite.rotation += rotation_speed * delta

func on_hit(damage):
	damage_taken_effect()
	.on_hit(damage)

func damage_taken_effect():
	$Sprite.scale = Vector2(0.33, 0.33)
	$Sprite.modulate = Color.white
	$Tween.interpolate_property($Sprite, "scale", $Sprite.scale, Vector2(0.48, 0.48), 0.25)
	$Tween.interpolate_property($Sprite, "modulate", $Sprite.modulate, Color(color), 0.5)
	$Tween.start()

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
			target.on_hit(stats["damage"])
