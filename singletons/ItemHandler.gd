extends Node

var item_base = preload("res://scenes/item/Item.tscn")
var items_data
var rarities = ["common", "uncommon", "rare", "epic", "legendary"]

# possible stats to get on an item, consider it a placeholder
var possible_stats = ["damage", "max_health", "attack_speed", "movement_speed", "defence"] 

func _ready():
	items_data = read_items_file()["items"]

func create_item():
	var new_item = item_base.instance()
	var items = items_data.keys()
	var random_item = items[randi() % items.size()]
	new_item.set_text(items_data[random_item]["name"])
	new_item.type = items_data[random_item]["type"]
	new_item.rarity = random_rarity(1)
	new_item.stats = random_stats(new_item.rarity)
	if items_data[random_item].has("primary_ability"):
		new_item.primary_ability_path = items_data[random_item]["primary_ability"]
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

func random_stats(rarity : String):
	var stats = {}
	var amount_of_stats = 1
	var stat_multiplier = 1.0
	
	match rarity:
		"uncommon":
			amount_of_stats = 2
			stat_multiplier = 1.5
		"rare":
			amount_of_stats = 3
			stat_multiplier = 2.0
		"epic":
			amount_of_stats = 4
			stat_multiplier = 2.5
		"legendary":
			amount_of_stats = 5
			stat_multiplier = 3.0
			
			
	for _i in range(amount_of_stats):
		var stat = possible_stats[randi() % possible_stats.size()]
		if stats.has(stat):
			stats[stat] += 1.0
		else:
			stats[stat] = 1.0 * stat_multiplier
	
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
