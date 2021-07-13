extends Position2D

onready var label = $Label
onready var tween = $Tween

var value
var color
var velocity = Vector2()

func _ready():
	label.text = str(value)
	label.set("custom_colors/font_color", color)
	velocity = Vector2(randi() % 101 - 50, 10)
	tween.interpolate_property(self, "scale", Vector2(1.25, 1.25), Vector2(0.1, 0.1), 0.6, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.4)
	tween.start()

func init_floating_number(val : float, col : Color):
	value = val
	color = col
	

func _process(delta):
	position += velocity * delta

func _on_Tween_tween_all_completed():
	queue_free()
