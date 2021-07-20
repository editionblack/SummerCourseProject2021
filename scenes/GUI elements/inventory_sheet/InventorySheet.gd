extends Control

onready var equipped_item_list = $Panel/EquippedItemList
onready var inventory_item_list = $Panel/InventoryItemList

var equipped_items = null
var inventory_items = null
var selected_e_item = null
var selected_i_item = null

var player

func _ready():
	theme.set_color("font_color", "TooltipLabel", Color.white)

func reload_inventory_sheet():
	equipped_items = player.get_items()
	inventory_items = player.get_inventory()
	reload_list(equipped_item_list, equipped_items)
	reload_list(inventory_item_list, inventory_items)

func reload_list(item_list, items):
	item_list.clear()
	
	var item_index = 0
	for item in items:
		item_list.add_item(item.get_name(), load("res://assets/sprites/square.png"), true)
		item_list.set_item_icon_modulate(item_index, item.get_rarity_color())
		item_list.set_item_tooltip(item_index, item.get_tooltip())
		item_index+=1

func _on_DiscardButton_pressed():
	if !selected_i_item:
		return
	player.item_discard(selected_i_item)
	reload_inventory_sheet()
	selected_i_item = null

func _on_EquipButton_pressed():
	equip()

func equip():
	if !selected_i_item:
		return
	var item_type = selected_i_item.type
	var item_with_same_type = null
	
	for item in equipped_items:
		if item.type == item_type:
			item_with_same_type = item
			break
	if item_with_same_type == null:
		player.item_equip(selected_i_item)
	else:
		player.item_unequip(item_with_same_type)
		player.item_equip(selected_i_item)
		
	reload_inventory_sheet()
	selected_i_item = null

func unequip():
	if !selected_e_item:
		return
	player.item_unequip(selected_e_item)
	reload_inventory_sheet()
	selected_e_item = null

func _on_UnequipButton_pressed():
	unequip()

func _on_InventoryItemList_item_selected(index):
	selected_i_item = inventory_items[index]

func _on_EquippedItemList_item_selected(index):
	selected_e_item = equipped_items[index]

func _on_InventoryItemList_item_activated(_index):
	equip()

func _on_EquippedItemList_item_activated(_index):
	unequip()
