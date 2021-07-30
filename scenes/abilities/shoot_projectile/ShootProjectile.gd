extends "res://scenes/abilities/AbilityTemplate.gd"

var projectile_scene = load("res://scenes/projectiles/basic_projectile/BasicProjectile.tscn")

func use_ability(direction):
	if !$AttackSpeed.is_stopped():
		return
	var damage_range = stats["base_damage"] if user.weapon == null else user.weapon.stats["weapon_damage"]
	var damage = DamageCalculationHandler.calculate_primary_damage(user, damage_range)
	var is_critical = false
	if "critical_chance" in user.stats:
		if user.stats["critical_chance"] > randi() % 101:
			is_critical = true
			damage *= user.stats["critical_damage"]
	var offset = 35 # distance from users origin
	var projectile = projectile_scene.instance()
	projectile.damage = damage
	projectile.is_critical = is_critical
	projectile.color = user.projectile_color
	projectile.user = user
	projectile.position = user.position + direction * offset
	projectile.direction = direction
	projectile.rotation = direction.angle()
	projectile.collision_mask = collision_mask
	world.call_deferred("add_child", projectile)
	
	ability_used()
	update_timer()
	$AttackSpeed.start()
