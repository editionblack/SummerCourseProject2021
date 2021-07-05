extends Node

var ability_data

func _ready():
	ability_data = read_ability_data("res://abilities.json")["abilities"]
	
func read_ability_data(path):
	var file = File.new()
	file.open(path, File.READ)
	return JSON.parse(file.get_as_text()).result

func get_ability(ability_name, collision_mask):
	var new_ability = load(ability_data[ability_name]["scene"]).instance()
	new_ability.world = get_tree().get_root()
	new_ability.collision_mask = collision_mask
	new_ability.stats = ability_data[ability_name]["stats"].duplicate(true)
	return new_ability
