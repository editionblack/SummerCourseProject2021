extends "res://scenes/abilities/AbilityTemplate.gd"

var in_use = false
var projectile_scene = load("res://scenes/projectiles/basic_projectile/BasicProjectile.tscn")

func use_ability(direction):
	if !$Cooldown.is_stopped() or in_use:
		return
	
	# snapshot the damage so that its consistent through the entire ability.
	var damage = stats["damage"]
	in_use = true
	for _i in range(stats["projectile_amount"]):
		var new_projectile = projectile_scene.instance()
		var offset = 35
		var adjusted_direction
		adjusted_direction = direction.rotated(deg2rad(randi() % int( (stats["spread"]*2+1) - stats["spread"] ) ) )
		new_projectile.damage = damage
		new_projectile.position = user.position + adjusted_direction * offset
		new_projectile.direction = adjusted_direction
		new_projectile.rotation = adjusted_direction.angle()
		new_projectile.collision_mask = collision_mask
		world.call_deferred("add_child", new_projectile)
		yield(get_tree().create_timer(stats["delay"]), "timeout")
	in_use = false
	ability_used()
	$Cooldown.start()
