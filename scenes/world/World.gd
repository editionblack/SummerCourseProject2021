extends Node2D

onready var HUD = $HUD
var player
var exit
var scaling = 1.0

func _ready():
	randomize()
	pick_class_and_restart()

func _physics_process(_delta):
	if HUD.get_node("Minimap").is_visible():
		update_minimap()

func pick_class_and_restart():
	HUD.hide_player_control()
	HUD.show_class_picker()
	var player_class = yield(HUD.get_node("ClassPicker"), "class_chosen")
	restart(player_class)
	HUD.hide_class_picker()

func restart(player_class):
	Global.reset_scaling()
	HUD.show_player_control()
	
	var level_start = LevelGenerator.generate_level($Navigation2D/TileMap)
	var player_start = $Navigation2D/TileMap.map_to_world(level_start) + Vector2(50, 50)
	var new_player = PlayerClassHandler.create_player(player_class)
	new_player.get_node("Camera2D").current = true
	new_player.global_position = player_start
	$Entities.call_deferred("add_child", new_player)
	new_player.connect("player_death", self, "_on_Player_death")
	new_player.connect("next_level", self, "_on_Next_level")
	new_player.connect("reset_game", self, "_on_Next_level")
	
	HUD.player = new_player
	HUD.inventory_sheet.player = new_player
	new_player.connect("item_pickup", HUD.inventory_sheet, "reload_inventory_sheet")
	HUD.player_control.set_player(new_player)
	# we "pass" the torch of player instance to the new player, and then discard the old player.
	# this fix ensures that the HUD always has a player instance.
	var old_player = player
	player = new_player
	if old_player:
		old_player.free()
	HUD.clear_minimap()
	HUD.show_minimap()
	LevelDirector.populate_level(self, level_start)

# code that should be moved to minimap
func update_minimap():
	var minimap = HUD.get_node("Minimap/TileMap")
	var tilemap = $Navigation2D/TileMap
	var player_cell = minimap.world_to_map(player.position)
	var exit_cell = minimap.world_to_map(exit.position)
	var offset = Vector2(1, 1)
	
	var size = 19
	for x in range(0, size):
		for y in range(0, size):
			if x == floor(size/2) and y == floor(size/2):
				minimap.set_cellv(Vector2(x,y) + offset, 2)
			else:
				var player_relative_tile = Vector2(player_cell.x + (-floor(size/2)+x), player_cell.y + (-floor(size/2)+y))
				if exit_cell == player_relative_tile:
					minimap.set_cellv(Vector2(x,y) + offset, 3)
				else:
					minimap.set_cellv(Vector2(x,y) + offset, tilemap.get_cellv(player_relative_tile))

func clear_entities():
	for entity in $Entities.get_children():
		if entity == player:
			continue
		entity.free()

func get_player():
	return player

func _on_Next_level():
	Global.increase_scaling(0.1)
	$AntiBugCamera2D.current = true
	clear_entities()
	HUD.clear_minimap()
	var level_start = LevelGenerator.generate_level($Navigation2D/TileMap)
	var player_start = $Navigation2D/TileMap.map_to_world(level_start) + Vector2(50, 50)
	$AntiBugCamera2D.global_position = player_start
	player.global_position = player_start
	player.get_node("Camera2D").reset_smoothing()
	player.get_node("Camera2D").current = true
	LevelDirector.populate_level(self, level_start)
	
func _on_Player_death():
	HUD.show_game_over()
	get_tree().paused = true
