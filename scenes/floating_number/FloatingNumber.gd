extends Position2D

onready var label = $Label
onready var tween = $Tween

var value
var velocity = Vector2()

func _ready():
	label.text = str(value)
	velocity = Vector2(randi() % 101 - 50, 10)
	tween.interpolate_property(self, "scale", Vector2(1, 1), Vector2(0.1, 0.1), 0.8, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.2)
	tween.start()
	
func _process(delta):
	position += velocity * delta

func _on_Tween_tween_all_completed():
	queue_free()
