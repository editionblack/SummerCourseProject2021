extends TextureProgress

var user
var gradient = preload("res://assets/gradients/healthbar_gradient.tres")
onready var tween = $Tween

func set_user(new_user):
	user = new_user
	max_value = user.stats["max_health"]
	value = user.stats["health"]
	user.connect("health_changed", self, "_on_Health_update")
	tint_progress = gradient.interpolate(float(value / max_value))

func _on_Health_update(new_value):
	max_value = user.stats["max_health"]
	tween.interpolate_property(self, "value", value, new_value, 0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.0)
	tween.start()
	
# this "only" runs 60 times per second which is less than _process, which isn't too many health-checks
# per second. could be rewritten such that an entity calls on "update_value" or something, but should
# suffice for now.
func _physics_process(_delta):
	tint_progress = gradient.interpolate(float(value / max_value))

