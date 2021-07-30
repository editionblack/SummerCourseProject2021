extends Node2D

var user = null
var stats = {}
var description = "test test test test"

func _physics_process(_delta):
	if user:
		pass
	else:
		user = get_parent()
		if user:
			user.connect("damage_dealt", self, "_on_User_dealt_damage")
			user.connect("damage_taken", self, "_on_User_damage_taken")
			user.connect("primary_used", self, "_on_User_primary_used")
			user.connect("secondary_used", self, "_on_User_secondary_used")

func _on_User_damage_taken(_value, _dealer, _is_critical):
	pass

func _on_User_dealt_damage(_value, _reciever, _is_critical):
	pass

func _on_User_primary_used():
	pass

func _on_User_secondary_used():
	pass

func get_stats():
	return stats
