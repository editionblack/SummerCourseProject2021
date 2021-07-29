extends "res://scenes/abilities/AbilityTemplate.gd"

var projectile_scene = load("res://scenes/projectiles/basic_projectile/BasicProjectile.tscn")

func use_ability(direction):
	if !$Cooldown.is_stopped():
		return
	
	# snapshot the damage so that its consistent through the entire ability.
	var damage = DamageCalculationHandler.calculate_secondary_damage(user, stats)
	var amount = int(stats["projectile_amount"])
	for i in range(amount):
		var new_projectile = projectile_scene.instance()
		var offset = 35
		var adjusted_direction
		adjusted_direction = direction.rotated(deg2rad((i - floor(amount / 2)) * 10))
		new_projectile.damage = damage
		new_projectile.color = user.projectile_color
		new_projectile.position = user.position + adjusted_direction * offset
		new_projectile.direction = adjusted_direction
		new_projectile.rotation = adjusted_direction.angle()
		new_projectile.collision_mask = collision_mask
		world.call_deferred("add_child", new_projectile)
	
	update_timer()
	ability_used()
	$Cooldown.start()
