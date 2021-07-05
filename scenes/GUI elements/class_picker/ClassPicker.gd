extends Control

signal class_chosen(player_class)

onready var item_list = $Panel/ItemList
onready var button = $Panel/Button


func _ready():
	var data = PlayerClassHandler.get_class_data()
	var i = 0
	for player_class in data.keys():
		item_list.add_item(player_class, load(data[player_class]["icon"]), true)
		item_list.set_item_icon_modulate(i, data[player_class]["icon_color"])
		i += 1

func _on_ItemList_item_selected(_index):
	button.disabled = false

func _on_Button_pressed():
	var selected_class = item_list.get_item_text(item_list.get_selected_items()[0])
	emit_signal("class_chosen", selected_class)

func _on_ItemList_nothing_selected():
	item_list.unselect_all()
	button.disabled = true

func reset_item_list():
	item_list.unselect_all()
	button.disabled = true
