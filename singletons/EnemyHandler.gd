extends Node

var enemy_data

func _ready():
	enemy_data = read_enemy_file("res://enemies.json")["enemies"]

func create_enemy(enemy_type):
	var enemy = load(enemy_data[enemy_type]["scene"]).instance()
	enemy.stats = enemy_data[enemy_type]["stats"].duplicate(true)
	enemy.stats["movement_speed"] += randi() % 51 - 25
	enemy.color = enemy_data[enemy_type]["color"]
	return enemy

func read_enemy_file(path):
	var file = File.new()
	file.open(path, File.READ)
	return  JSON.parse(file.get_as_text()).result
