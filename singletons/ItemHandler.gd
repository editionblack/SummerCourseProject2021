extends Node

var item_base = preload("res://scenes/item/Item.tscn")
var items_data
var rarity_value = {"common" : 1, "uncommon" : 2, "rare" : 3, "epic" : 4, "legendary" : 5}


func _ready():
	items_data = read_items_file()["items"]

func create_item(item_type = null, specific_item = null):
	var new_item = item_base.instance()
	var item = null
	if !specific_item:
		var item_types = items_data.keys()
		var random_item_type = item_types[randi() % item_types.size()]
		var items = items_data[random_item_type].keys()
		var random_item = items[randi() % items.size()]
		item = items_data[random_item_type][random_item].duplicate(true)
	else:
		item = items_data[item_type][specific_item].duplicate(true)
	
	new_item.set_text(item["name"] + " lvl " + str(Global.get_level()))
	
	if !specific_item:
		new_item.type = item["type"]
		new_item.rarity = random_rarity(1)
		new_item.stats = random_stats(new_item.rarity, item)
	else:
		new_item.type = item["type"]
		new_item.rarity = "common"
		new_item.stats = item["base_stats"]
	if item.has("primary_ability"):
		new_item.primary_ability = item["primary_ability"]
	return new_item

# placeholder rarity function. TODO: make it based on a "luck"-stat
func random_rarity(_luck : int):
	var rarities = rarity_value.keys()
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

func random_stats(rarity : String, item : Dictionary):
	var stats = {}
	var rarity_power = rarity_value[rarity]
	var scaling = Global.get_scaling()
	var base_stats = item["base_stats"]

	stats = base_stats
	for stat in stats:
		match stat:
			"weapon_damage":
				var base_weapon_damage = base_stats["weapon_damage"]
				var deviance = rand_range(0.75, 1.50)
				var min_weapon_damage = stepify(base_weapon_damage[0] + rarity_power * deviance * scaling, 0.1)
				var max_weapon_damage = stepify(base_weapon_damage[1] + rarity_power * deviance * scaling, 0.1)
				stats["weapon_damage"] = [min_weapon_damage, max_weapon_damage]
			"weapon_attack_speed":
				var weapon_attack_speed = base_stats["weapon_attack_speed"]
				var deviance = rand_range(0.75, 1.50)
				stats["weapon_attack_speed"] = stepify(weapon_attack_speed * deviance, 0.1)
			_:
				var base_stat = stats[stat]
				# the item can deviate by 25% less than the base or 50% more than the base
				var deviance = rand_range(0.75, 1.50)
				
				# items with a rarity of uncommon or higher gets 25% stronger base, up to 100%
				var rarity_modifier = 1.0 + (rarity_power - 1 / 4)
				
				base_stat = base_stat * rarity_modifier * deviance * scaling
				base_stat = stepify(base_stat, 0.1)
				stats[stat] = base_stat
	
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
