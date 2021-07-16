extends Node

func calculate_primary_damage(user, damage_range : Array):
	var bonus_damage = user.stats["damage"]
	return stepify(rand_range(damage_range[0], damage_range[1]) + bonus_damage, 0.1)
	
