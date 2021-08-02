extends Control

onready var scroll_container = $Panel/ScrollContainer/VBoxContainer

# reload values that are typically "static".
func reload_character_sheet():
	var player = get_parent().player
	if !player:
		return
	scroll_container.get_node("Class/Value").text = player.current_class
	scroll_container.get_node("PrimaryAbility/Value").text = player.primary_ability.name
	scroll_container.get_node("SecondaryAbility/Value").text = player.secondary_ability.name + " - "
	scroll_container.get_node("PassiveAbility/Value").text = player.passive_ability.name
	scroll_container.get_node("PassiveAbility").hint_tooltip = player.passive_ability.description

func _physics_process(_delta):
	var player = get_parent().player
	if !player:
		return
		
	scroll_container.get_node("Health/Value").text = str(player.stats["health"]) + " / " + str(player.stats["max_health"])
	
	if player.weapon:
		var damage_range = DamageCalculationHandler.get_damage_range(player, player.weapon.stats["weapon_damage"])
		var attack_speed = DamageCalculationHandler.get_attack_speed(player, player.weapon.stats["weapon_attack_speed"])
		scroll_container.get_node("Damage/Value").text = str(damage_range[0]) + " - " + str(damage_range[1])
		scroll_container.get_node("AttackSpeed/Value").text = str(attack_speed) + " / second"
	else:
		var damage_range = DamageCalculationHandler.get_damage_range(player, player.primary_ability.stats["base_damage"])
		var attack_speed = DamageCalculationHandler.get_attack_speed(player, player.primary_ability.stats["base_attack_speed"])
		scroll_container.get_node("Damage/Value").text = str(damage_range[0]) + " - " + str(damage_range[1])
		scroll_container.get_node("AttackSpeed/Value").text = str(attack_speed) + " / second"
	scroll_container.get_node("MovementSpeed/Value").text = str(player.stats["movement_speed"])
	scroll_container.get_node("Defence/Value").text = str(player.stats["defence"])
	scroll_container.get_node("SecondaryAbility/Value2").text = str(player.secondary_ability.get_node("Cooldown").wait_time) + "s"
	scroll_container.get_node("CriticalChance/Value").text = str(player.stats["critical_chance"]) + "%"
	scroll_container.get_node("CriticalDamage/Value").text = str(player.stats["critical_damage"] * 100 - 100) + "%"
	scroll_container.get_node("Lifesteal/Value").text = str(player.stats["lifesteal"]) + "% of damage dealt"
	scroll_container.get_node("CooldownReduction/Value").text = str(player.stats["cooldown_reduction"]) + "%"
	scroll_container.get_node("AbilityPower/Value").text = str(player.stats["ability_power"])
