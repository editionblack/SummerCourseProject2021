extends TextureProgress

var user
var gradient = preload("res://assets/gradients/healthbar_gradient.tres")
onready var tween = $Tween

func _ready():
	user = get_parent()
	max_value = user.stats["max_health"]
	value = user.stats["health"]
	user.connect("health_changed", self, "_on_Health_update")
	tint_progress = gradient.interpolate(float(value / max_value))

func _on_Health_update(new_value):
	tween.interpolate_property(self, "value", value, new_value, 0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.0)
	tween.start()
	
# this "only" runs 60 times per second which is less than _process, which isn't too many health-checks
# per second. could be rewritten such that an entity calls on "update_value" or something, but should
# suffice for now.
func _physics_process(_delta):
	tint_progress = gradient.interpolate(float(value / max_value))
#	actual_health = user.stats["health"]
#	if actual_health != value:
#		value = lerp(value, actual_health, 0.25)
#	if value >= float(max_value * 0.99):
#		value = max_value
#	tint_progress = gradient.interpolate(float(value / max_value))
