extends KinematicBody2D

var stats
var targets = []
var color = null

var can_move = true
var is_stunned = false
var nav2d = null
var path = []
var world = null
var player = null

var velocity = Vector2()

func _ready():
	$Sprite.modulate = color
	world = get_tree().get_root().get_node("World")
	nav2d = world.get_node("Navigation2D")
	player = world.get_node("Entities/Player")

func _process(_delta):
	# if we are stunned and cant move there is nothing to do this frame.
	# attacks or such should still process if we aren't stunned but can't move.
	# subject to change but it's fine for now.
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
		if global_position.distance_to(path[0]) < 1:
			path.remove(0)
		else:
			return (path[0] - global_position).normalized()
	return Vector2(0, 0)

func distance_to_player():
	return global_position.distance_to(player.global_position)

func get_path_to_player():
	return nav2d.get_simple_path(global_position, player.global_position, false)

func on_hit(damage):
	damage_taken_effect()
	stats["health"] -= damage
	if stats["health"] <= 0:
		drop_item()
		queue_free()

func damage_taken_effect():
	$Sprite.scale = Vector2(0.33, 0.33)
	$Sprite.modulate = Color.white
	$Tween.interpolate_property($Sprite, "scale", $Sprite.scale, Vector2(0.48, 0.48), 0.25)
	$Tween.interpolate_property($Sprite, "modulate", $Sprite.modulate, Color(color), 0.25)
	$Tween.start()

func drop_item():
	var item = ItemHandler.create_item()
	item.global_position = global_position
	get_parent().call_deferred("add_child", item)

func move():
	pass

func attack():
	pass
