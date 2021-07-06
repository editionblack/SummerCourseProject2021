extends "res://scenes/enemies/EnemyTemplate.gd"

func _ready():
	._ready()
	$DamageTimer.wait_time = stats["damage_frequency"]

func _process(_delta):
	if is_stunned or !can_move:
		return
	var player = world.get_player()
	$RayCast2D.cast_to = player.global_position - global_position
	$RayCast2D.force_raycast_update()
	var raycast_collision = $RayCast2D.get_collider()
	if raycast_collision != player:
		return
	var direction = (player.global_position - global_position).normalized()
	var _velocity = move_and_slide(direction * stats["movement_speed"])

func _physics_process(delta):
	if !is_stunned:
		$Sprite.rotation += 5 * delta

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
