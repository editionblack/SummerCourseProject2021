extends Node

# to create a little variation with damage, even if a weapon is not equipped.
const BASE_UPPER = 1.25
const BASE_LOWER = 0.75

func calculate_primary_damage(user):
	return stepify(rand_range(calculate_lower_damage(user), calculate_upper_damage(user)), 0.01)
	
func calculate_upper_damage(user):
	var user_damage = user.stats["damage"] * 1.25
	var weapon_damage = 0
	if user.weapon:
		weapon_damage = user.weapon.stats["weapon_damage"][1]
	return int(user_damage + weapon_damage)

func calculate_lower_damage(user):
	var user_damage = user.stats["damage"] * 0.75
	var weapon_damage = 0
	if user.weapon:
		weapon_damage = user.weapon.stats["weapon_damage"][0]
	return int(user_damage  + weapon_damage)
