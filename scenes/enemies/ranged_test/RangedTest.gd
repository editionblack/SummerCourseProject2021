extends "res://scenes/enemies/EnemyTemplate.gd"

var ability

func _ready():
	._ready()
	ability = AbilityHandler.get_ability("shoot_projectile", 1+2)
	call_deferred("add_child", ability)

func attack():
	$RayCast2D.cast_to = player.global_position - global_position
	$RayCast2D.force_raycast_update()
	var collider = $RayCast2D.get_collider()
	if collider == player:
		ability.use_ability((player.global_position - global_position).normalized())
