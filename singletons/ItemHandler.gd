extends Node

var item_base = preload("res://scenes/item/Item.tscn")
var items_data
var rarities = ["common", "uncommon", "rare", "epic", "legendary"]
var rarity_value = {"common" : 1, "uncommon" : 2, "rare" : 3, "epic" : 4, "legendary" : 5}

# possible stats to get on an item, consider it a placeholder
var possible_stats = ["damage", "max_health", "attack_speed", "movement_speed", "defence"]


func _ready():
	items_data = read_items_file()["items"]

func create_item():
	var new_item = item_base.instance()
	var item_types = items_data.keys()
	var random_item_type = item_types[randi() % item_types.size()]
	var items = items_data[random_item_type].keys()
	var random_item = items[randi() % items.size()]
	var item = items_data[random_item_type][random_item]
	new_item.set_text(item["name"])
	new_item.type = item["type"]
	new_item.rarity = random_rarity(1)
	new_item.stats = random_stats(new_item.rarity, new_item.type)
	if item.has("primary_ability"):
		new_item.primary_ability = item["primary_ability"]
	return new_item

# placeholder rarity function. TODO: make it based on a "luck"-stat
func random_rarity(_luck : int):
	if randi() % 101 > 50:
		return rarities[0]
	if randi() % 101 > 50:
		return rarities[1]
	if randi() % 101 > 50:
		return rarities[2]
	if randi() % 101 > 50:
		return rarities[3]
	if randi() % 101 > 50:
		return rarities[4]
	return rarities[0]

func random_stats(rarity : String, type : String):
	var stats = {}
	var rarity_power = rarity_value[rarity]
	var scaling = Global.get_scaling()
	
	match type:
		"weapon":
			stats["weapon_damage"] = [(5 + rarity_power) * scaling, (10 + rarity_power) * scaling]
			stats["weapon_attack_speed"] = rand_range(0.5, 2.0)
		"chest":
			stats["max_health"] = 25 + (5 * rarity_power) * scaling
			stats["defence"] = 2.0 + (0.2 * rarity_power) * scaling
		"head":
			stats["max_health"] = 15 + (2.5 * rarity_power) * scaling
			stats["defence"] = 1.0 + (0.1 * rarity_power) * scaling
		"boots":
			stats["movement_speed"] = 25 + (5 * rarity_power) * scaling
			stats["defence"] = 0.5 + (0.1 * rarity_power) * scaling
		"gloves":
			stats["attack_speed"] = 0.5
			stats["defence"] = 1.5 + (0.1 * rarity_power) * scaling
	for stat in stats:
		var value = stats[stat]
		if value is Array:
			for el in value:
				el = stepify(el, 0.01)
		else:
			value = stepify(value, 0.01)
	
	return stats
	

# debug tool to check how common different rarities are
func test_rarity_function(iterations):
	var result = {"common" : 0, "uncommon" : 0, "rare" : 0, "epic" : 0, "legendary" : 0}
	for _i in range(iterations):
		result[random_rarity(1)] += 1
	print("Done!")
	print(result)

func read_items_file():
	var file = File.new()
	file.open("res://items.json", File.READ)
	return JSON.parse(file.get_as_text()).result
