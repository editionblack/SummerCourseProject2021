extends "res://scenes/abilities/AbilityTemplate.gd"

onready var hit_sound = $HitSound

func _ready():
	hide_weapon()

func use_ability(direction):
	if !$AttackSpeed.is_stopped() or $AnimationPlayer.is_playing():
		return
	
	rotation = direction.angle()
	$Area2D.collision_mask = collision_mask
	$Area2D/CollisionShape2D.disabled = false
	$AnimationPlayer.play("attack")
	yield($AnimationPlayer, "animation_finished")
	$Area2D/CollisionShape2D.disabled = true
	
	ability_used()
	update_timer()
	$AttackSpeed.start()

# used so that the weapon + effect can still be visible in the editor but hides once it
# enters a scene.
func hide_weapon():
	$Area2D/CollisionShape2D.disabled = true
	$Area2D/SwordSprite.visible = false
	$Area2D/Particles2D.emitting = false

func _on_Area2D_body_entered(body):
	if body.has_method("on_hit"):
		hit_sound.play()
		var damage = stats["base_damage"] if user.weapon == null else user.weapon.stats["weapon_damage"]
		CombatHandler.hit(body, user, damage, "primary")
