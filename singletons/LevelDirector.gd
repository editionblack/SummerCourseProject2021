extends Node

func populate_level(world, level_start):
	var scaling = Global.get_scaling()
	
	var tilemap = world.get_node("Navigation2D/TileMap")
	var floor_cells = []
	
	# get all the floor tiles where we can spawn stuff
	for cell in tilemap.get_used_cells():
		if tilemap.get_cellv(cell) == 1:
			floor_cells.append(cell)
	
	# safety margin - don't spawn anything in a x by y grid near the player
	for x in range(5):
		for y in range(5):
			floor_cells.erase(Vector2(level_start.x + (x - 2), level_start.y + (y - 2)))
	
	var furthest_away = level_start
	# calculate the furthest cell from spawn
	for floor_cell in floor_cells:
		if floor_cell.distance_to(level_start) > furthest_away.distance_to(level_start):
			furthest_away = floor_cell
	floor_cells.erase(furthest_away)
	
	# randomly spawn in enemies and loot
	for floor_cell in floor_cells:
		if randi() % 101 > 95.0 - scaling / 2.0:
			spawn_enemy(world, tilemap.map_to_world(floor_cell) + Vector2(50, 50))
	spawn_entrance(world, tilemap.map_to_world(level_start) + Vector2(50, 50))
	spawn_exit(world, tilemap.map_to_world(furthest_away) + Vector2(50, 50))

func spawn_entrance(world, position):
	var new_entrance = load("res://scenes/entrance/Entrance.tscn").instance()
	new_entrance.global_position = position
	world.get_node("Entities").call_deferred("add_child", new_entrance)

func spawn_exit(world, position):
	var new_exit = load("res://scenes/exit/Exit.tscn").instance()
	new_exit.global_position = position
	world.exit = new_exit
	world.get_node("Entities").call_deferred("add_child", new_exit)

func spawn_enemy(world, position):
	var new_enemy = EnemyHandler.create_enemy(["chaser", "ranged_test", "bomber"][randi() % 3])
	new_enemy.global_position = position
	world.get_node("Entities").call_deferred("add_child", new_enemy)
	
func spawn_item(world, position):
	var new_item = ItemHandler.create_item()
	new_item.global_position = position
	world.get_node("Entities").call_deferred("add_child", new_item)
