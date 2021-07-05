extends Control

onready var grid_container = $Panel/ScrollContainer/GridContainer
var stat_box_container = preload("StatBoxContainer.tscn")

func reload_character_sheet():
	for child in grid_container.get_children():
		child.queue_free()
	grid_container.add_child(new_stat_box("Class", get_parent().player.current_class, true))
	grid_container.add_child(new_stat_box("Primary ability", get_parent().player.primary_ability.name, true))
	grid_container.add_child(new_stat_box("Secondary ability", get_parent().player.secondary_ability.name, true))
	var player_stats = get_parent().player.stats
	for key in player_stats.keys():
		grid_container.add_child(new_stat_box(key, str(player_stats[key]), false))

func _physics_process(_delta):
	if visible and grid_container.get_child_count() > 0:
		var player_stats = get_parent().player.stats
		for child in grid_container.get_children():
			if child.static_value:
				continue
			child.set_stat_value(str(player_stats[child.get_key()]))

func new_stat_box(text, value, is_static):
	var result = stat_box_container.instance()
	result.set_stat_name(text)
	result.set_stat_value(value)
	result.set_static_value(is_static)
	return result

