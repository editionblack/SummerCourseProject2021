extends "res://scenes/abilities/AbilityTemplate.gd"

func _ready():
	._ready()
	$AttackSpeed.wait_time = 1.0 / user.stats["attack_speed"]

func use_ability(direction):
	if !$AttackSpeed.is_stopped() or $AnimationPlayer.is_playing():
		return
	
	rotation = direction.angle()
	$Area2D.collision_mask = collision_mask
	$Area2D/CollisionShape2D.disabled = false
	$AnimationPlayer.play("attack")
	yield($AnimationPlayer, "animation_finished")
	$Area2D/CollisionShape2D.disabled = true
	
	$AttackSpeed.start()


func _on_Area2D_body_entered(body):
	if body.has_method("on_hit"):
		body.on_hit(user.stats["damage"])
