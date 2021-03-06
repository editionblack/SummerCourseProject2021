extends KinematicBody2D

signal player_death
signal next_level
signal item_pickup
signal reset_game
signal health_changed(new_value)
# warning-ignore:unused_signal
signal resource_changed(new_value)
signal damage_taken(value, dealer)
# warning-ignore:unused_signal
signal damage_dealt(value, reciever, is_critical)
# warning-ignore:unused_signal
signal primary_used()
# warning-ignore:unused_signal
signal secondary_used()

var floating_number = preload("res://scenes/floating_number/FloatingNumber.tscn")
onready var hurt_sound = $HurtSound


var world = null
var velocity = Vector2()
var last_direction = Vector2.UP
var can_move = true
var is_stunned = false
var current_class
var base_stats
var stats
var resource
var starter_weapon
var weapon = null
var projectile_color
var original_scale


var current_interactable = null
var close_interactables = []

var base_primary_ability
var primary_ability
var secondary_ability
var utility_ability
var passive_ability

var color = Color.white

func _ready():
	original_scale = $Sprite.scale
	base_stats = stats.duplicate(true)
	$Sprite.modulate = color
	utility_ability = AbilityHandler.get_ability("dash", 1 + 4)
	add_child(utility_ability)
	var starter_item = ItemHandler.create_item(["weapon", starter_weapon])
	starter_item.disable_interaction()
	item_equip(starter_item)
	# warning-ignore:return_value_discarded
	connect("damage_dealt", self, "_on_Player_damage_dealt")
	
func _process(_delta):
	if can_move:
		move()
	else:
		velocity = move_and_slide(velocity)
	
	
	var direction_of_mouse = (get_global_mouse_position() - position).normalized()
	if Input.is_action_pressed("left_click"):
		primary_ability.use_ability(direction_of_mouse)
	if Input.is_action_pressed("right_click"):
		secondary_ability.use_ability(direction_of_mouse)
	if Input.is_action_pressed("utility"):
		utility_ability.use_ability(direction_of_mouse)
		
func _unhandled_input(event):
	if event.is_action_pressed("interact", false):
		if current_interactable:
			match current_interactable.get_groups()[0]:
				"exits":
					emit_signal("next_level")
				"items":
					item_pick_up(current_interactable)
				_:
					print("Nothing!")
	
	if event.is_action_pressed("reset", false):
		emit_signal("reset_game")
		
# checks for input and moves in appropiate direction
func move():
	var direction = Vector2()
	var movement_speed = stats["movement_speed"]
	
	if Input.is_action_pressed("w"):
		direction.y += -1
	if Input.is_action_pressed("s"):
		direction.y += 1
	if Input.is_action_pressed("a"):
		direction.x += -1
	if Input.is_action_pressed("d"):
		direction.x += 1
	
	
	direction = direction.normalized()
	
	if direction != Vector2():
		last_direction = direction
	
	if direction != Vector2():
		velocity = lerp(velocity, direction * movement_speed, 0.1)
	else:
		velocity = lerp(velocity, Vector2(), 0.05)
	
	var _unhandled = move_and_slide(velocity)
	
func get_items():
	return $Items.get_children()
	
func get_inventory():
	return $Inventory.get_children()

func item_pick_up(item):
	item.reparent()
	$Inventory.add_child(item)
	item.disable_interaction()
	emit_signal("item_pickup")
	
func item_equip(item):
	if $Inventory.get_children().has(item):
		$Inventory.remove_child(item)
	$Items.add_child(item)
	item.user = self
	if item.type == "weapon":
		weapon = item
		switch_ability(item.primary_ability)
	recalculate_stats()
	
func item_unequip(item):
	if item.type == "weapon":
		weapon = null
		switch_ability(base_primary_ability)
	item.user = null
	$Items.remove_child(item)
	$Inventory.add_child(item)
	recalculate_stats()

func item_discard(item):
	if $Items.get_children().has(item):
		$Items.remove_child(item)
	if $Inventory.get_children().has(item):
		$Inventory.remove_child(item)
	item.queue_free()

func switch_ability(ability_name : String):
	if primary_ability:
		remove_child(primary_ability)
		primary_ability.call_deferred("queue_free")
	var new_primary_ability = AbilityHandler.get_ability(ability_name, 1 + 4)
	add_child(new_primary_ability)
	primary_ability = new_primary_ability

func recalculate_stats():
	for stat in stats:
		if stat == "health": # workaround so that items wont heal the player on every recalc
			continue
		var accumulator = 0
		for item in $Items.get_children():
			if item.get_stats().has(stat):
				accumulator += item.get_stats()[stat]
		stats[stat] = base_stats[stat] + accumulator
	emit_signal("health_changed", stats["health"])

func on_hit(damage, dealer, is_critical = false):
	damage_taken_effect()
	hurt_sound.play()
	stats["health"] -= DamageCalculationHandler.calculate_damage_reduction(self, damage)
	emit_signal("health_changed", stats["health"])
	if stats["health"] <= 0:
		emit_signal("player_death")
		collision_layer = 0
	else:
		emit_signal("damage_taken", damage, dealer, is_critical)

func damage_taken_effect():
	$Sprite.scale = original_scale / 1.3
	$Sprite.modulate = Color.red
	$Tween.interpolate_property($Sprite, "scale", $Sprite.scale, original_scale, 0.25)
	$Tween.interpolate_property($Sprite, "modulate", $Sprite.modulate, Color(color), 0.25)
	$Tween.start()


func _on_Player_damage_dealt(value, _reciever, _is_critical):
	if stats["lifesteal"] > 0 and stats["health"] < stats["max_health"]:
		var previous_health = stats["health"]
		var healing_power = stepify(value * (stats["lifesteal"] / 100), 0.1)
		stats["health"] = clamp(previous_health + healing_power, 0, stats["max_health"])
		var new_floating_number = floating_number.instance()
		new_floating_number.init_floating_number(stats["health"] - previous_health, Color.lightgreen, Vector2(1.25, 1.25))
		new_floating_number.position = position
		world.call_deferred("add_child", new_floating_number)
		emit_signal("health_changed", stats["health"])

func _on_InteractRange_area_entered(area):
	close_interactables.append(area.get_parent())
	
	if current_interactable == null:
		area.get_parent().set_highlight(true)
		current_interactable = area.get_parent()
		$InteractLabel.visible = true

func _on_InteractRange_area_exited(area):
	close_interactables.erase(area.get_parent())
	
	if current_interactable == area.get_parent():
		area.get_parent().set_highlight(false)
		current_interactable = null
		$InteractLabel.visible = false
		
		if close_interactables.size() > 0:
			close_interactables[0].set_highlight(true)
			current_interactable = close_interactables[0]
			$InteractLabel.visible = true
