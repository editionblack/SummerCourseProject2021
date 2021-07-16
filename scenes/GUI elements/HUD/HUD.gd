extends CanvasLayer

onready var character_sheet = $CharacterSheet
onready var game_over = $GameOverPanel
onready var class_picker = $ClassPicker
onready var inventory_sheet = $InventorySheet
onready var minimap = $Minimap
onready var level_label = $LevelLabel

var player

func _ready():
	game_over.connect("reset_game", self, "_on_Game_reset")
	var _conn_value = Global.connect("level_changed", self, "set_level_label")

func _unhandled_input(event):
	if event.is_action_pressed("c") and !class_picker.visible:
		if !character_sheet.visible:
			character_sheet.reload_character_sheet()
		character_sheet.visible = !character_sheet.visible
	if event.is_action_pressed("i") and !class_picker.visible:
		if !inventory_sheet.visible:
			inventory_sheet.reload_inventory_sheet()
		inventory_sheet.visible = !inventory_sheet.visible
	if event.is_action_pressed("tab") and !class_picker.visible:
		minimap.visible = !minimap.visible
		
func show_class_picker():
	class_picker.visible = true

func hide_class_picker():
	class_picker.visible = false
	class_picker.reset_item_list()

func show_minimap():
	minimap.visible = true

func clear_minimap():
	minimap.get_node("TileMap").clear()

func show_level_label():
	level_label.visible = true
	
func hide_level_label():
	level_label.visible = false

func show_game_over():
	character_sheet.visible = false
	inventory_sheet.visible = false
	minimap.visible = false
	game_over.visible = true

func hide_game_over():
	game_over.visible = false

func set_level_label(value : int):
	level_label.text = "Level: " + str(value)

func _on_Game_reset():
	get_parent().clear_entities()
	get_parent().player.queue_free()
	get_tree().paused = false
	hide_game_over()
	get_parent().pick_class_and_restart()
