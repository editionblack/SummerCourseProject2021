extends Particles2D

var color = null

func _ready():
	modulate = color
	emitting = true
	one_shot = true
