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
signal damage_dealt(value, reciever)
# warning-ignore:unused_signal
signal primary_used()
# warning-ignore:unused_signal
signal secondary_used()

var world = null
var velocity = Vector2()
var can_move = true
var is_stunned = false
var current_class
var base_stats
var stats
var resource
var starter_weapon
var weapon = null

var current_interactable = null
var close_interactables = []

var base_primary_ability
var primary_ability
var secondary_ability
var utility_ability
var passive_ability

var color = Color.white

func _ready():
	base_stats = stats.duplicate(true)
	$Sprite.modulate = color
	utility_ability = AbilityHandler.get_ability("dash", 1 + 4)
	add_child(utility_ability)
	var starter_item = ItemHandler.create_item("weapons", starter_weapon)
	starter_item.disable_interaction()
	item_equip(starter_item)
	
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

func on_hit(damage, dealer):
	damage_taken_effect()
	
	stats["health"] -= DamageCalculationHandler.calculate_damage_reduction(self, damage)
	emit_signal("health_changed", stats["health"])
	if stats["health"] <= 0:
		emit_signal("player_death")
		collision_layer = 0
	else:
		emit_signal("damage_taken", damage, dealer)

func damage_taken_effect():
	$Sprite.scale = Vector2(0.38, 0.38)
	$Sprite.modulate = Color.white
	$Tween.interpolate_property($Sprite, "scale", $Sprite.scale, Vector2(0.48, 0.48), 0.25)
	$Tween.interpolate_property($Sprite, "modulate", $Sprite.modulate, Color(color), 0.25)
	$Tween.start()


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
