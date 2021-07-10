extends Node

const width = 200
const height = 200
const walk_amount = 120
const step_amount = 5

func generate_level(tilemap : TileMap):
	tilemap.clear()
	var visited_coordinates = []
	
	fill(tilemap, 0)
			
	var starting_points = [Vector2(1, 1)] #Vector2(1, height-2), Vector2(width-2, 1), Vector2(width-2, height-2)]
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
		
		for _step in range(randi() % step_amount + 1):
			var next_step = current_point + current_direction
			if next_step.x == 0 or next_step.x == width-1 or next_step.y == 0 or next_step.y == height-1:
				break
			current_point = next_step
			if !visited_coordinates.has(current_point):
				visited_coordinates.append(current_point)
	for coordinate in visited_coordinates:
		tilemap.set_cell(coordinate.x, coordinate.y, 1)
	return starting_point

func fill(tilemap : TileMap, cell_id : int):
	for i in range(-10, width+10):
		for j in range(-10, height+10):
			tilemap.set_cell(i, j, cell_id)
