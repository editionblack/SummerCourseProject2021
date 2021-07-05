extends Node2D

var stats
var type 
var rarity
var rarity_colors = {"common" : Color.white, "uncommon" : Color.mediumseagreen, "rare" : Color.mediumblue, "epic" : Color.mediumpurple, "legendary" : Color.gold}
var primary_ability_path = null


func _ready():
	$Sprite.self_modulate = rarity_colors[rarity]

func _on_Area2D_body_entered(body):
	call_deferred("reparent", body)

func reparent(new_parent):
	get_parent().remove_child(self)
	new_parent.item_pick_up(self)

func get_rarity_color():
	return rarity_colors[rarity]

func get_stats():
	return stats

func get_name():
	return $Label.text

func set_text(text):
	$Label.text = text

func get_tooltip():
	var result = get_name() + '\n' + "- - - - - - - - - - - -" + '\n'
	for stat in stats:
		result += stat + " : " + str(stats[stat])
		result += '\n'
	return result
