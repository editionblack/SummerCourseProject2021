extends KinematicBody2D

signal player_death
signal item_pickup

var velocity = Vector2()
var can_move = true
var is_stunned = false
var current_class
var base_stats
var stats

var primary_ability
var secondary_ability
var abilities_held_down = [] # to be processed every frame and used if possible

var color = Color.white

func _ready():
	base_stats = stats.duplicate(true)
	$Sprite.modulate = color
	
func _process(_delta):
	if can_move:
		move()
	else:
		velocity = move_and_slide(velocity)
		
	for ability in abilities_held_down:
		ability.use_ability((get_global_mouse_position() - position).normalized())
		
	#stats["health"] += 0.1
	#stats["health"] = clamp(stats["health"], 0, stats["max_health"])

# so that the player doesn't accidentally attack while using menus.
func _unhandled_input(event):
	if event.is_action_pressed("left_click", true):
		abilities_held_down.append(primary_ability)
	if event.is_action_released("left_click"):
		abilities_held_down.erase(primary_ability)
		
	if event.is_action_pressed("right_click", true):
		abilities_held_down.append(secondary_ability)
	if event.is_action_released("right_click"):
		abilities_held_down.erase(secondary_ability)

# checks for input and moves in appropiate direction
func move():
	var direction = Vector2()
	
	if Input.is_action_pressed("w"):
		direction.y += -1
	if Input.is_action_pressed("s"):
		direction.y += 1
	if Input.is_action_pressed("a"):
		direction.x += -1
	if Input.is_action_pressed("d"):
		direction.x += 1
	
	direction = direction.normalized()
	velocity = move_and_slide(direction * stats["movement_speed"])

func get_items():
	return $Items.get_children()
	
func get_inventory():
	return $Inventory.get_children()

func item_pick_up(item):
	$Inventory.add_child(item)
	item.visible = false
	emit_signal("item_pickup")
	
func item_equip(item):
	$Inventory.remove_child(item)
	$Items.add_child(item)
	if item.type == "weapon":
		remove_child(primary_ability)
		primary_ability.call_deferred("queue_free")
		var new_primary_ability = AbilityHandler.get_ability(item.primary_ability_path, 1 + 4)
		call_deferred("add_child", new_primary_ability)
		primary_ability = new_primary_ability
	recalculate_stats()
	
func item_unequip(item):
	$Items.remove_child(item)
	$Inventory.add_child(item)
	recalculate_stats()

func item_discard(item):
	if $Items.get_children().has(item):
		$Items.remove_child(item)
	if $Inventory.get_children().has(item):
		$Inventory.remove_child(item)
		
func recalculate_stats():
	for stat in stats:
		if stat == "health": # workaround so that items wont heal the player on every recalc
			continue
		var accumulator = 0
		for item in $Items.get_children():
			if item.get_stats().has(stat):
				accumulator += item.get_stats()[stat]
		stats[stat] = base_stats[stat] + accumulator
	$Healthbar.max_value = stats["max_health"]

func on_hit(damage):
	damage_taken_effect()
	
	# could be replaced by some math stuff?? fine for now
	# for the first ten defence points the damage is reduced by 3%
	# for every ten points the 3% is halved.
	var defence_points = stats["defence"]
	var damage_reduction = 0
	var reduction_per_point = 3.0
	var i = 0
	while defence_points - i > 0:
		damage_reduction += reduction_per_point
		i += 1
		if i % 10 == 0:
			reduction_per_point /= 2.0
	damage -= damage * (damage_reduction / 100)
	stats["health"] -= damage 
	if stats["health"] <= 0:
		emit_signal("player_death")
		$CollisionShape2D.disabled = true

func damage_taken_effect():
	$Sprite.scale = Vector2(0.38, 0.38)
	$Sprite.modulate = Color.white
	$Tween.interpolate_property($Sprite, "scale", $Sprite.scale, Vector2(0.48, 0.48), 0.25)
	$Tween.interpolate_property($Sprite, "modulate", $Sprite.modulate, Color(color), 0.5)
	$Tween.start()
