extends Node2D

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
	return $Label.text

func set_text(text):
	$Label.text = text

func set_highlight(state):
	$Highlight.visible = state

func get_tooltip():
	var result = get_name() + '\n' + "- - - - - - - - - - - -" + '\n'
	for stat in stats:
		result += stat + " : " + str(stats[stat])
		result += '\n'
	return result
