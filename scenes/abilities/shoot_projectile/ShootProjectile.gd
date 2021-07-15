extends "res://scenes/abilities/AbilityTemplate.gd"

var projectile_scene = load("res://scenes/projectiles/basic_projectile/BasicProjectile.tscn")

func _ready():
	$AttackSpeed.wait_time = 1.0 / user.stats["attack_speed"] 

func use_ability(direction):
	if !$AttackSpeed.is_stopped():
		return
	
	var offset = 35 # distance from users origin
	var projectile = projectile_scene.instance()
	projectile.damage = DamageCalculationHandler.calculate_primary_damage(user)
	projectile.position = user.position + direction * offset
	projectile.direction = direction
	projectile.rotation = direction.angle()
	projectile.collision_mask = collision_mask
	world.call_deferred("add_child", projectile)
	
	update_timer()
	$AttackSpeed.start()
