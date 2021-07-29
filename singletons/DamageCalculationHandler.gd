extends Node

func calculate_primary_damage(user, damage_range : Array):
	var bonus_damage = user.stats["damage"]
	if "passive_ability" in user:
		var stats = user.passive_ability.get_stats()
		if "damage" in stats:
			bonus_damage += stats["damage"]
	return stepify(rand_range(damage_range[0], damage_range[1]) + bonus_damage, 0.1)

func calculate_secondary_damage(user, ability_stats):
	var bonus_ap = 0
	if "passive_ability" in user:
		var stats = user.passive_ability.get_stats()
		if "ability_power" in stats:
			bonus_ap += stats["ability_power"]
	var ap_modifier = (1.0 + ( (user.stats["ability_power"]+bonus_ap) / ability_stats["ability_power_scaling"]))
	var final_damage = ability_stats["damage"] * ap_modifier
	return stepify(final_damage, 0.1)
	
func get_damage_range(user, damage_range : Array):
	var bonus_damage = user.stats["damage"]
	if "passive_ability" in user:
		var stats = user.passive_ability.get_stats()
		if "damage" in stats:
			bonus_damage += stats["damage"]
	return [stepify(damage_range[0] + bonus_damage, 0.1), stepify(damage_range[1] + bonus_damage, 0.1)]

func get_attack_speed(user, base_attack_speed : float):
	return base_attack_speed * (1.0 + (user.stats["attack_speed"] / 100.0))

func calculate_damage_reduction(user, damage):
	# could be replaced by some math stuff?? fine for now
	# for the first ten defence points the damage is reduced by 3%
	# for every ten points the 3% is halved.
	var defence_points = user.stats["defence"]
	var damage_reduction = 0
	var reduction_per_point = 3.0
	var i = 0
	while defence_points - i > 0:
		damage_reduction += reduction_per_point
		i += 1
		if i % 10 == 0:
			reduction_per_point /= 2.0
	return stepify((damage - (damage * (damage_reduction / 100))), 0.1)
