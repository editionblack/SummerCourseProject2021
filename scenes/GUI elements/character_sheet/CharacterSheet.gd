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
	var bonus_damage = player.stats["damage"]
	if player.weapon:
		grid_container.get_node("DamageRange/Value").text = str(player.weapon.stats["weapon_damage"][0] + bonus_damage) + " - " + str(player.weapon.stats["weapon_damage"][1] + bonus_damage)
		grid_container.get_node("AttackSpeed/Value").text = str(player.weapon.stats["weapon_attack_speed"] * (1.0 + (player.stats["attack_speed"] / 100.0))) + " / second"
	else:
		grid_container.get_node("DamageRange/Value").text = str(player.primary_ability.stats["base_damage"][0] + bonus_damage) + " - " + str(player.primary_ability.stats["base_damage"][1] + bonus_damage)
		grid_container.get_node("AttackSpeed/Value").text = str(player.primary_ability.stats["base_attack_speed"] * (1.0 + (player.stats["attack_speed"] / 100.0))) + " / second"
	grid_container.get_node("MovementSpeed/Value").text = str(player.stats["movement_speed"])
	grid_container.get_node("Defence/Value").text = str(player.stats["defence"])


func new_stat_box(text, value, is_static):
	var result = stat_box_container.instance()
	result.set_stat_name(text)
	result.set_stat_value(value)
	result.set_static_value(is_static)
	return result

