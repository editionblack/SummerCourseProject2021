extends Node2D

var user = null
var stats
var type 
var rarity
var rarity_colors = {"common" : Color.white, "uncommon" : Color.mediumseagreen, "rare" : Color.dodgerblue, "epic" : Color.mediumpurple, "legendary" : Color.gold}
var primary_ability = null


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

func set_text(text):
	$Node2D/Label.text = text

func set_highlight(state):
	$Highlight.visible = state

func get_tooltip():
	var result = rarity.to_upper() + '\n' + get_name() + '\n' + "- - - - - - - - - - - -" + '\n'
	match type:
		"weapon":
			result += "Damage : " + str(stats["weapon_damage"][0]) + " - " + str(stats["weapon_damage"][1])
			result += '\n'
			result += "Attacks/second : " + str(stats["weapon_attack_speed"])
			result += '\n'
			
		_:
			for stat in stats:
				result += stat + " : " + str(stats[stat])
				result += '\n'
	return result
