extends Particles2D

func _ready():
	emitting = true
	one_shot = true

func _physics_process(_delta):
	if emitting == false:
		queue_free()
