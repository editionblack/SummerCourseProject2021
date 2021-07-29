extends "res://scenes/enemies/EnemyTemplate.gd"

var explosion_particles = preload("res://scenes/particles/explosion/Explosion.tscn")
onready var animation_player = $AnimationPlayer
onready var timer = $Timer
onready var hurtbox = $Hurtbox


func _ready():
	animation_player.play("Blinking")
	timer.wait_time = stats["explosion_delay"]

func attack():
	if distance_to_player() < 100 and timer.is_stopped():
		can_move = false
		animation_player.playback_speed = 4
		timer.start()

func move():
	var direction = Vector2(0,0)
	
	# raycast to player. If hit, the direction is set towards the player. If not, we find a direction to move towards through
	# pathfinding.
	if !is_player_in_sight():
		direction = pathfind_direction_to_player()
	else:
		path = []
		direction = (player.global_position - global_position).normalized()
	
	velocity = move_and_slide(direction * stats["movement_speed"])


func _on_Timer_timeout():
	var new_explosion_particle = explosion_particles.instance()
	new_explosion_particle.position = position
	world.call_deferred("add_child", new_explosion_particle)
	for body in hurtbox.get_overlapping_bodies():
		body.on_hit(stats["damage"], self)
	queue_free()
