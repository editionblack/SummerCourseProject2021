extends HBoxContainer

export var static_value = false

# for values that we do not want to or need to update
func set_static_value(boolean):
	static_value = boolean

func set_stat_name(text):
	$StatName.text = text

func set_stat_value(value):
	$StatValue.text = value

func get_key():
	return $StatName.text
