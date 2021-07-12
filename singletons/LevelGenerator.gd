extends Node

const width = 100
const height = 100
const walk_amount = 150
const step_amount = 5
const least_amount = 1

func generate_level(tilemap : TileMap):
	tilemap.clear()
	var visited_coordinates = []
	
	fill(tilemap, 0)
			
	var starting_points = [Vector2(1, 1), Vector2(1, height-2), Vector2(width-2, 1), Vector2(width-2, height-2)]
	var starting_point = starting_points[randi() % starting_points.size()]
	var current_point = starting_point
	visited_coordinates.append(current_point)
	var current_direction = null
	
	for _walk in range(walk_amount):
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
		
		for _step in range(randi() % step_amount + least_amount):
			var next_step = current_point + current_direction
			if next_step.x == 0 or next_step.x == width-1 or next_step.y == 0 or next_step.y == height-1:
				break
			current_point = next_step
			if !visited_coordinates.has(current_point):
				visited_coordinates.append(current_point)
	for coordinate in visited_coordinates:
		tilemap.set_cell(coordinate.x, coordinate.y, 1)
	smooth_out_map(tilemap)
	return starting_point
	
func smooth_out_map(tilemap : TileMap):
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
			if clean_copy.get_cellv(Vector2(x, y)) == 0 and walls < 2:
				tilemap.set_cellv(Vector2(x,y), 1)
				
func fill(tilemap : TileMap, cell_id : int):
	for i in range(-10, width+10):
		for j in range(-10, height+10):
			tilemap.set_cell(i, j, cell_id)
