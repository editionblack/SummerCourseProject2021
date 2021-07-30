extends "res://scenes/abilities/AbilityTemplate.gd"

func _ready():
	$Area2D/SpearSprite.visible = false
	$Area2D/CollisionShape2D.disabled = true

func use_ability(direction):
	if !$AttackSpeed.is_stopped():
		return
	
	rotation = direction.angle()
	$Area2D.collision_mask = collision_mask
	$AnimationPlayer.play("stab")
	
	ability_used()
	update_timer()
	$AttackSpeed.start()


func _on_Area2D_body_entered(body):
	if body.has_method("on_hit"):
		var damage = stats["base_damage"] if user.weapon == null else user.weapon.stats["weapon_damage"]
		CombatHandler.hit(body, user, damage, "primary")
