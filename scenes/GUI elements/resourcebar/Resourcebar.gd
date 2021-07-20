extends TextureProgress

var user

func set_user(new_user):
	user = new_user
	user.connect("resource_changed", self, "_on_Resource_update")
	max_value = user.resource["max_resource"]
	value = user.resource["resource"]
	tint_progress = Color(user.resource["color"])

func _on_Resource_update(new_value):
	value = new_value
