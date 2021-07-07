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
	clear_entities()
	
	var new_player = PlayerClassHandler.create_player(player_class)
	new_player.get_node("Camera2D").current = true
	new_player.global_position = $PlayerSpawn.position
	$Entities.call_deferred("add_child", new_player)
	new_player.connect("player_death", self, "_on_Player_death")
	
	HUD.player = new_player
	HUD.inventory_sheet.player = new_player
	new_player.connect("item_pickup", HUD.inventory_sheet, "reload_inventory_sheet")
	player = new_player
	
	$SpawnTimer.start()

func clear_entities():
	for entity in $Entities.get_children():
		entity.queue_free()

func get_player():
	return player

func _on_SpawnTimer_timeout():
	var new_enemy = EnemyHandler.create_enemy("chaser")
	new_enemy.global_position = $SpawnPoints.get_children()[randi() % $SpawnPoints.get_children().size()].global_position
	$Entities.call_deferred("add_child", new_enemy)

func _on_Player_death():
	$SpawnTimer.stop()
	HUD.show_game_over()
	get_tree().paused = true
