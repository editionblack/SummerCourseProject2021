extends Control

onready var grid_container = $Panel/ScrollContainer/GridContainer
var stat_box_container = preload("StatBoxContainer.tscn")

# reload values that are typically "static".
func reload_character_sheet():
	var player = get_parent().player
	if !player:
		return
	grid_container.get_node("Class/Value").text = player.current_class
	grid_container.get_node("PrimaryAbility/Value").text = player.primary_ability.name
	grid_container.get_node("SecondaryAbility/Value").text = player.secondary_ability.name

func _physics_process(_delta):
	var player = get_parent().player
	if !player:
		return
		
	grid_container.get_node("Health/Value").text = str(player.stats["health"]) + " / " + str(player.stats["max_health"])
	
	if player.weapon:
		var damage_range = DamageCalculationHandler.get_damage_range(player, player.weapon.stats["weapon_damage"])
		var attack_speed = DamageCalculationHandler.get_attack_speed(player, player.weapon.stats["weapon_attack_speed"])
		grid_container.get_node("DamageRange/Value").text = str(damage_range[0]) + " - " + str(damage_range[1])
		grid_container.get_node("AttackSpeed/Value").text = str(attack_speed) + " / second"
	else:
		var damage_range = DamageCalculationHandler.get_damage_range(player, player.primary_ability.stats["base_damage"])
		var attack_speed = DamageCalculationHandler.get_attack_speed(player, player.primary_ability.stats["base_attack_speed"])
		grid_container.get_node("DamageRange/Value").text = str(damage_range[0]) + " - " + str(damage_range[1])
		grid_container.get_node("AttackSpeed/Value").text = str(attack_speed) + " / second"
	grid_container.get_node("MovementSpeed/Value").text = str(player.stats["movement_speed"])
	grid_container.get_node("Defence/Value").text = str(player.stats["defence"])


func new_stat_box(text, value, is_static):
	var result = stat_box_container.instance()
	result.set_stat_name(text)
	result.set_stat_value(value)
	result.set_static_value(is_static)
	return result

