extends Control

var player
var is_player_set = false

onready var player_health = $PlayerHealthBar
onready var player_health_label = $HealthLabel
onready var player_resource_label = $ResourceLabel
onready var player_resource = $Node2D/PlayerResourceBar
onready var player_secondary_ability = $SecondaryAbilityBar

func _physics_process(_delta):
	if player:
		player_health_label.text = str(player.stats["health"]) + " / " + str(player.stats["max_health"])
		player_resource_label.text = str(player.resource["resource"]) + " / " + str(player.resource["max_resource"])
	if player and player.secondary_ability and player.secondary_ability.has_node("Cooldown"):
		var cooldown = player.secondary_ability.get_node("Cooldown")
		if player.secondary_ability.has_node("Cooldown"):
			player_secondary_ability.max_value = cooldown.wait_time
			player_secondary_ability.value = cooldown.wait_time - cooldown.time_left
			if cooldown.is_stopped():
				player_secondary_ability.get_node("Label").text = "READY"
			else:
				player_secondary_ability.get_node("Label").text = str(stepify(cooldown.time_left, 0.5))

func set_player(new_player):
	player = new_player
	player_health.set_user(new_player)
	player_resource.set_user(new_player)
	

