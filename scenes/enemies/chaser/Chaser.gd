extends KinematicBody2D

var stats
var targets = []
var color = null
var accent_color = null

var can_move = true
var is_stunned = false

func _ready():
	$DamageTimer.wait_time = stats["damage_frequency"]
	$Sprite.self_modulate = color
	for child_sprite in $Sprite.get_children():
		child_sprite.self_modulate = accent_color

func _process(_delta):
	if !is_stunned and can_move:
		var world = get_parent().get_parent()
		var player = world.get_player()
		var direction = (player.global_position - global_position).normalized()
		var _velocity = move_and_slide(direction * stats["movement_speed"])

func _physics_process(delta):
	if !is_stunned:
		$Sprite.rotation += 5 * delta

func on_hit(damage):
	$Sprite.scale = Vector2(0.33, 0.33)
	$Sprite.modulate = Color.gray
	$Tween.interpolate_property($Sprite, "scale", $Sprite.scale, Vector2(0.48, 0.48), 0.25)
	$Tween.interpolate_property($Sprite, "modulate", $Sprite.modulate, Color.white, 0.5)
	$Tween.start()
	stats["health"] -= damage
	if stats["health"] <= 0:
		drop_item()
		queue_free()

func drop_item():
	var item = ItemHandler.create_item()
	item.global_position = global_position
	get_parent().call_deferred("add_child", item)

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
