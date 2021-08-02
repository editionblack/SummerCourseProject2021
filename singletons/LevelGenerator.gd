extends Node

const width = 100
const height = 100
var walk_amount = 5
var step_amount = 7
var least_amount = 8
var room_size = Vector2(3, 3)
var enabled_smoothing = true

func generate_level(tilemap : TileMap):
	var scaling = Global.get_scaling()
	
	tilemap.clear()
	var visited_coordinates = []
	
	fill(tilemap, 0)
	
	var starting_point = Vector2(width/2.0, height/2.0)
	var current_point = starting_point
	visited_coordinates.append(current_point)
	var current_direction = null
	
	for _walk in range(walk_amount + (Global.get_level() - 1) * 5):
		var directions = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]
		
		if current_point.x - 1 == 0:
			directions.erase(Vector2.LEFT)
		if current_point.x + 1 == width-1:
			directions.erase(Vector2.RIGHT)
		if current_point.y - 1 == 0:
			directions.erase(Vector2.UP)
		if current_point.y + 1 == height-1:
			directions.erase(Vector2.DOWN)
		if current_direction:
			directions.erase(current_direction)
	
		current_direction = directions[randi() % directions.size()]
		for step in step_amount:
			var next_step = current_point + current_direction
			if next_step.x == 0 or next_step.x == width-1 or next_step.y == 0 or next_step.y == height-1:
				break
			current_point = next_step
			if !visited_coordinates.has(current_point):
				visited_coordinates.append(current_point)
			if step == step_amount - 1:
				generate_room(room_size, current_point, visited_coordinates, true)
	generate_room(room_size, starting_point, visited_coordinates)
	for coordinate in visited_coordinates:
		tilemap.set_cell(coordinate.x, coordinate.y, 1)
	if enabled_smoothing:
		smooth_out_map(tilemap)
	return starting_point

# adds positions to COORDINATES in x by z SIZE grid. Starts in the MIDDLE pos.
# if RANDOM_MODE enabled, the room layout will be chosen from a list of generated layouts
func generate_room(size : Vector2, middle : Vector2, coordinates : Array, random_mode = false):
	var current_position = middle - size/2 + Vector2(1,1)
	if random_mode:
		var rooms = []
		for i in range(2, 7):
			for j in range(2, 7):
				var layout = Vector2(i, j)
				if not layout in rooms:
					rooms.append(layout)
		size = rooms[randi() % rooms.size() - 1]
	for x in range(size.x):
		for y in range(size.y):
			var room_tile = current_position + Vector2(x,y)
			coordinates.append(room_tile) 

func smooth_out_map(tilemap : TileMap, wall_limit = 2):
	var clean_copy = tilemap.duplicate()
	for x in range(0, width):
		for y in range(0, height):
			var walls = 0
			for i in range(x - 1, x + 1):
				for j in range(y - 1, y + 1):
					if i == x and j == y:
						continue
					if clean_copy.get_cellv(Vector2(i,j)) == 0:
						walls += 1
			if clean_copy.get_cellv(Vector2(x, y)) == 0 and walls < wall_limit:
				tilemap.set_cellv(Vector2(x,y), 1)
				
func fill(tilemap : TileMap, cell_id : int):
	for i in range(-10, width+10):
		for j in range(-10, height+10):
			tilemap.set_cell(i, j, cell_id)
