extends KinematicBody2D

signal health_changed(new_value)
#warning-ignore:unused_signal
signal primary_used()
#warning-ignore:unused_signal
signal secondary_used()

var stats
var targets = []
var color = null
var initial_scale

var awake = false
var can_move = true
var is_stunned = false
var nav2d = null
var path = []
var world = null
var player = null

var weapon = null

var velocity = Vector2()

var floating_number = preload("res://scenes/floating_number/FloatingNumber.tscn")

func _ready():
	add_to_group("enemies")
	$Sprite.modulate = color
	initial_scale = $Sprite.scale
	world = get_tree().get_root().get_node("World")
	nav2d = world.get_node("Navigation2D")
	scale_stats()
	$Node2D/Healthbar.set_user(self)

func _process(_delta):
	if !awake and $VisibilityNotifier2D.is_on_screen():
		awake = true
	if !awake:
		return
	# if we are stunned and cant move there is nothing to do this frame.
	# attacks or such should still process if we aren't stunned but can't move.
	# subject to change but it's fine for now.
	
	player = world.player
	
	if is_stunned:
		return
	attack()
	if !can_move:
		return
	move()

func is_player_in_sight():
	$RayCast2D.cast_to = player.global_position - global_position
	$RayCast2D.force_raycast_update()
	var raycast_collision = $RayCast2D.get_collider()
	
	return true if raycast_collision == player else false

func pathfind_direction_to_player():
	if path.empty() or path[path.size() - 1].distance_to(player.global_position) > 100:
		path = get_path_to_player()
	if !path.empty():
		if global_position.distance_to(path[0]) < 2:
			path.remove(0)
		else:
			return (path[0] - global_position).normalized()
	return Vector2(0, 0)

func distance_to_player():
	return global_position.distance_to(player.global_position)

func get_path_to_player():
	return nav2d.get_simple_path(global_position, player.global_position, false)

func on_hit(damage, dealer):
	damage_taken_effect()
	var fdn = floating_number.instance()
	fdn.init_floating_number(damage, Color.lightcoral)
	fdn.position = position
	world.add_child(fdn)
	stats["health"] -= damage
	emit_signal("health_changed", stats["health"])
	if dealer:
		dealer.emit_signal("damage_dealt", damage, self)
	if stats["health"] <= 0:
		die()

func die():
	if randi() % 101 >= 0:
		drop_item()
	queue_free()

func damage_taken_effect():
	$Sprite.scale = initial_scale / 1.3
	$Sprite.modulate = Color.white
	$Tween.interpolate_property($Sprite, "scale", $Sprite.scale, initial_scale, 0.25)
	$Tween.interpolate_property($Sprite, "modulate", $Sprite.modulate, Color(color), 0.25)
	$Tween.start()

func drop_item():
	var item = ItemHandler.create_item()
	item.global_position = global_position
	get_parent().call_deferred("add_child", item)

func scale_stats():
	var current_scaling = Global.get_scaling()
	stats["damage"] *= current_scaling
	stats["max_health"] *= current_scaling
	stats["health"] *= current_scaling
	emit_signal("health_changed", stats["health"])
	
func move():
	pass

func attack():
	pass
