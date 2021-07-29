extends Area2D

onready var particles = preload("res://scenes/projectiles/basic_projectile/HitParticles.tscn")
onready var world = get_tree().get_root().get_node("World/Entities")
onready var sprite = $Sprite

var direction = Vector2()
var user = null
var speed = 600
var damage = 0
var spent = false
var color = null

func _ready():
	sprite.modulate = color

func _process(delta):
	position += direction.normalized() * speed * delta

func _on_Basic_projectile_body_entered(body):
	if body.has_method("on_hit") and spent == false:
		body.on_hit(damage, user)
		spent = true
	create_particles()
	queue_free()

func create_particles():
	var new_particles = particles.instance()
	new_particles.global_position = global_position
	new_particles.color = color
	world.call_deferred("add_child", new_particles)
