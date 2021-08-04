extends Node2D

var user = null
var stats
var type 
var rarity
var rarity_colors = {"common" : Color.white, "uncommon" : Color.mediumseagreen, "rare" : Color.dodgerblue, "epic" : Color.mediumpurple, "legendary" : Color.gold}
var primary_ability = null
var passive = null

func _ready():
	$Sprite.self_modulate = rarity_colors[rarity]
	
func reparent():
	get_parent().remove_child(self)

func get_rarity_color():
	return rarity_colors[rarity]

func get_stats():
	return stats

func get_name():
	return $Node2D/Label.text

func disable_interaction():
	$Area2D/CollisionShape2D.disabled = true
	visible = false

func set_text(text):
	$Node2D/Label.text = text

func set_highlight(state):
	$Highlight.visible = state

func get_tooltip():
	var result = rarity.to_upper() + '\n' + get_name() + '\n' + "- - - - - - - - - - - -" + '\n'
	for stat in stats:
		match stat:
			"weapon_damage":
				result += "Weapon Damage: " + str(stats["weapon_damage"][0]) + " - " + str(stats["weapon_damage"][1])
			
			"weapon_attack_speed":
				result += "Attacks per Second: " + str(stats["weapon_attack_speed"])
				
			"ability_power", "defence", "damage", "movement_speed", "max_health":
				if stats[stat] > 0:
					result += stat.capitalize() + ": +" + str(stats[stat])
				else:
					result += stat.capitalize() + ": " + str(stats[stat])
			
			"attack_speed", "cooldown_reduction", "critical_chance", "critical_damage", "lifesteal":
				if stats[stat] > 0:
					result += stat.capitalize() + ": +" + str(stats[stat]) + "%"
				else:
					result += stat.capitalize() + ": " + str(stats[stat]) + ("%")
		result += '\n'
	return result
