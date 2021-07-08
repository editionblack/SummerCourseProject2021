extends Node2D

onready var HUD = $HUD
var player

func _ready():
	randomize()
	pick_class_and_restart()
	
func pick_class_and_restart():
	HUD.show_class_picker()
	var player_class = yield(HUD.get_node("ClassPicker"), "class_chosen")
	restart(player_class)
	HUD.hide_class_picker()

func restart(player_class):
	var level_start = LevelGenerator.generate_level($Navigation2D/TileMap)
	var player_start = $Navigation2D/TileMap.map_to_world(level_start) + Vector2(50, 50)
	var new_player = PlayerClassHandler.create_player(player_class)
	new_player.get_node("Camera2D").current = true
	new_player.global_position = player_start
	$Entities.call_deferred("add_child", new_player)
	new_player.connect("player_death", self, "_on_Player_death")
	new_player.connect("next_level", self, "_on_Next_level")
	
	HUD.player = new_player
	HUD.inventory_sheet.player = new_player
	new_player.connect("item_pickup", HUD.inventory_sheet, "reload_inventory_sheet")
	player = new_player
	
	LevelDirector.populate_level(self, level_start)

func clear_entities():
	for entity in $Entities.get_children():
		if entity == player:
			continue
		entity.queue_free()

func get_player():
	return player

func _on_Next_level():
	clear_entities()
	var level_start = LevelGenerator.generate_level($Navigation2D/TileMap)
	var player_start = $Navigation2D/TileMap.map_to_world(level_start) + Vector2(50, 50)
	player.global_position = player_start
	LevelDirector.populate_level(self, level_start)
	
func _on_Player_death():
	HUD.show_game_over()
	get_tree().paused = true
