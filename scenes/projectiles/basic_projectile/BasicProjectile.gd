extends Area2D

onready var particles = preload("res://scenes/projectiles/basic_projectile/HitParticles.tscn")
onready var world = get_tree().get_root().get_node("World/Entities")
onready var sprite = $Sprite
onready var projectile_hit = preload("res://scenes/sound_players/ProjectileHit.tscn")

var direction = Vector2()
var user = null
var damage = null
var speed = 600
var spent = false
var color = null
var is_critical = false

func _ready():
	sprite.modulate = color

func _process(delta):
	position += direction.normalized() * speed * delta

func _on_Basic_projectile_body_entered(body):
	if body.has_method("on_hit") and spent == false:
		CombatHandler.hit_with_calculated_damage(body, user, damage, is_critical)
		spent = true
	var new_sound = projectile_hit.instance()
	new_sound.position = position
	world.call_deferred("add_child", new_sound)
	create_particles()
	queue_free()

func create_particles():
	var new_particles = particles.instance()
	new_particles.global_position = global_position
	new_particles.color = color
	world.call_deferred("add_child", new_particles)
