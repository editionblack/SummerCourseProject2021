extends Node

func hit(target, dealer, damage, type : String):
	var actual_damage = 0
	if type == "primary":
		actual_damage = DamageCalculationHandler.calculate_primary_damage(dealer, damage)
	elif type == "secondary":
		actual_damage = DamageCalculationHandler.calculate_secondary_damage(dealer, damage)
	
	var is_critical = false
	if "critical_chance" in dealer.stats:
		if dealer.stats["critical_chance"] > randi() % 101:
			is_critical = true
			actual_damage *= dealer.stats["critical_damage"]
	target.on_hit(actual_damage, dealer, is_critical)

# everything including crits has already been calculated.
# used for projectiles that on hit isnt guaranteed to have a user
# still alive.
func hit_with_calculated_damage(target, dealer, damage, is_critical):
	target.on_hit(damage, dealer, is_critical)
