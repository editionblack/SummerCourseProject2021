extends Node2D

onready var HUD = $HUD
var player
var exit

func _ready():
	randomize()
	pick_class_and_restart()

func _physics_process(_delta):
	if HUD.get_node("Minimap").is_visible():
		update_minimap()

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
	new_player.connect("reset_game", self, "_on_Next_level")
	
	HUD.player = new_player
	HUD.inventory_sheet.player = new_player
	new_player.connect("item_pickup", HUD.inventory_sheet, "reload_inventory_sheet")
	player = new_player
	HUD.clear_minimap()
	HUD.show_minimap()
	LevelDirector.populate_level(self, level_start)

# code that should be moved to minimap
func update_minimap():
	var minimap = HUD.get_node("Minimap/TileMap")
	var tilemap = $Navigation2D/TileMap
	var cells = tilemap.get_used_cells()
	var player_cell = minimap.world_to_map(player.position)
	var exit_cell = minimap.world_to_map(exit.position)
	var vision_range = 5
	var offset = Vector2(1, 1)
	
	var size = 13
	
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
#	for cell in cells:
#		if cell.x >= player_cell.x - vision_range and cell.x <= player_cell.x + vision_range and cell.y >= player_cell.y - vision_range and cell.y <= player_cell.y + vision_range:
#			minimap.set_cellv(cell + offset, tilemap.get_cellv(cell))
#			if cell == exit_cell:
#				minimap.set_cellv(cell + offset, 3)
#	minimap.set_cellv(player_cell + offset, 2)

func clear_entities():
	for entity in $Entities.get_children():
		if entity == player:
			continue
		entity.queue_free()

func get_player():
	return player

func _on_Next_level():
	clear_entities()
	HUD.clear_minimap()
	var level_start = LevelGenerator.generate_level($Navigation2D/TileMap)
	var player_start = $Navigation2D/TileMap.map_to_world(level_start) + Vector2(50, 50)
	player.global_position = player_start
	LevelDirector.populate_level(self, level_start)
	
func _on_Player_death():
	HUD.show_game_over()
	get_tree().paused = true
