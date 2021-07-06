extends KinematicBody2D

var stats
var targets = []
var color = null

var can_move = true
var is_stunned = false
var nav2d = null
var path = []
var world = null

var velocity = Vector2()

func _ready():
	$Sprite.modulate = color
	world = get_tree().get_root().get_node("World")
	nav2d = world.get_node("Navigation2D")


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

func on_hit(damage):
	stats["health"] -= damage
	if stats["health"] <= 0:
		drop_item()
		queue_free()

func drop_item():
	var item = ItemHandler.create_item()
	item.global_position = global_position
	get_parent().call_deferred("add_child", item)

func move():
	pass

func attack():
	pass
