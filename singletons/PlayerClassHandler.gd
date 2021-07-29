extends Node

var player_base = load("res://scenes/player/Player.tscn")
var class_data

func _ready():
	class_data = read_class_data("res://classes.json")["classes"]

func create_player(player_class : String):
	var new_player = player_base.instance()
	new_player.stats = class_data[player_class]["stats"].duplicate(true)
	new_player.resource = class_data[player_class]["resource"].duplicate(true)
	new_player.current_class = player_class
	new_player.color = class_data[player_class]["icon_color"]
	new_player.projectile_color = class_data[player_class]["projectile_color"]
	new_player.starter_weapon = class_data[player_class]["starter_weapon"]
	new_player.base_primary_ability = class_data[player_class]["primary"]
	var secondary_ability = AbilityHandler.get_ability(class_data[player_class]["secondary"], 1 + 4)
	new_player.secondary_ability = secondary_ability
	new_player.add_child(secondary_ability)
	var passive_ability = load(class_data[player_class]["passive"]).instance()
	new_player.passive_ability = passive_ability
	new_player.add_child(passive_ability)
	return new_player

func get_class_data():
	return class_data

func read_class_data(path):
	var file = File.new()
	file.open(path, File.READ)
	return JSON.parse(file.get_as_text()).result
