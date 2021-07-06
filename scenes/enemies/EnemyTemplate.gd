extends KinematicBody2D

var stats
var targets = []
var color = null
var accent_color = null

var can_move = true
var is_stunned = false
var nav2d = null
var path = []
var world = null

func _ready():
	$Sprite.modulate = color
	world = get_tree().get_root().get_node("World")
	nav2d = world.get_node("Navigation2D")

func on_hit(damage):
	stats["health"] -= damage
	if stats["health"] <= 0:
		drop_item()
		queue_free()

func drop_item():
	var item = ItemHandler.create_item()
	item.global_position = global_position
	get_parent().call_deferred("add_child", item)

