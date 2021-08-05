extends Node

var item_base = preload("res://scenes/item/Item.tscn")
var items_data
var rarity_value = {"common" : 1, "uncommon" : 2, "rare" : 3, "epic" : 4, "legendary" : 5}
var stat_values = {"max_health" : [10.0, 200.0], 
				"defence" : [2.0, 10.0], 
				"damage" : [2.0, 20.0], 
				"ability_power" : [2.0, 20.0],
				"cooldown_reduction" : [1.0, 10.0],
				"movement_speed" : [5, 150],
				"attack_speed" : [5.0, 100.0],
				"critical_chance" : [1.0, 25.0],
				"critical_damage" : [1.0, 50.0],
				"lifesteal" : [1.0, 25.0]}

func _ready():
	items_data = read_items_file()

# specific item should be an array with item_type [0] and item_name [1]
func create_item(specific_item = null):
	var new_item = item_base.instance()
	var item_type
	var item_name
	var item
	if specific_item == null:
		var item_types = items_data.keys()
		item_type = item_types[randi() % item_types.size()]
		var items = items_data[item_type].keys()
		item_name = items[randi() % items.size()]
		item = items_data[item_type][item_name].duplicate(true)
		new_item.rarity = random_rarity(1)
		new_item.stats = generate_random_stats(new_item.rarity, item)
		new_item.set_text(item_name + " LVL " + str(Global.get_level()))
	else:
		item_type = specific_item[0]
		item_name = specific_item[1]
		item = items_data[item_type][item_name].duplicate(true)
		new_item.rarity = "common"
		new_item.stats = item["base_stats"]
		new_item.set_text("Starter " + item_name)
		
	new_item.type = item_type
	if "primary_ability" in item:
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

func generate_random_stats(rarity : String, item : Dictionary):
	var result = {}
	var scaling = Global.get_scaling()
	# assign and scale base modifiers
	result = item["base_stats"]
	for stat in result:
		match stat:
			"weapon_damage":
				var base_weapon_damage = result["weapon_damage"]
				var deviance = rand_range(0.75, 1.50)
				var min_weapon_damage = stepify(base_weapon_damage[0] * deviance * scaling, 0.1)
				var max_weapon_damage = stepify(base_weapon_damage[1] * deviance * scaling, 0.1)
				result["weapon_damage"] = [min_weapon_damage, max_weapon_damage]
			"weapon_attack_speed":
				var weapon_attack_speed = result["weapon_attack_speed"]
				var deviance = rand_range(0.5, 1.5)
				result["weapon_attack_speed"] = stepify(weapon_attack_speed * deviance, 0.1)
			_:
				var random_stat_min = stat_values[stat][0] * clamp(scaling / 5.0, 0.0, 1.0)
				var random_stat_max = stat_values[stat][1] * clamp(scaling / 5.0, 0.0, 1.0)
				result[stat] = stepify(rand_range(random_stat_min, random_stat_max), 0.1)
				
	# assign and scale random modifiers
	var stat_pool = item["potential_stats"]
	for _i in rarity_value[rarity]:
		# choose a random stat from potential stats, get the minimum value and maximum value (is nullable)
		var random_stat = stat_pool[randi() % stat_pool.size()]
		var random_stat_min = stat_values[random_stat][0] * clamp(scaling / 5.0, 0.0, 1.0)
		var random_stat_max = stat_values[random_stat][1] * clamp(scaling / 5.0, 0.0, 1.0)
		if not random_stat in result:
			var random_value = rand_range(random_stat_min, random_stat_max)
			result[random_stat] = stepify(random_value, 0.1)
	return result

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
