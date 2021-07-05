extends Area2D

onready var particles = preload("res://scenes/projectiles/basic_projectile/HitParticles.tscn")

var direction = Vector2()
var speed = 600
var damage = 0
var spent = false

func _process(delta):
	position += direction.normalized() * speed * delta

func _on_Basic_projectile_body_entered(body):
	if body.has_method("on_hit") and spent == false:
		body.on_hit(damage)
		spent = true
	create_particles()
	queue_free()

func create_particles():
	var new_particles = particles.instance()
	new_particles.global_position = global_position
	get_parent().call_deferred("add_child", new_particles)