extends TileMap

func _ready():
	$CanvasLayer/VBoxContainer/HBoxContainer/ScalingSpinBox.value = Global.scaling
	$CanvasLayer/VBoxContainer/HBoxContainer2/StepSpinBox.value = LevelGenerator.step_amount
	$CanvasLayer/VBoxContainer/HBoxContainer3/WalkSpinBox.value = LevelGenerator.walk_amount
	$CanvasLayer/VBoxContainer/CheckBox.pressed = LevelGenerator.enabled_smoothing
	$CanvasLayer/VBoxContainer/HBoxContainer4/RoomX.value = LevelGenerator.room_size.x
	$CanvasLayer/VBoxContainer/HBoxContainer4/RoomY.value = LevelGenerator.room_size.y
	

func _input(event):
	if event.is_action_released("reset"):
		LevelGenerator.generate_level(self)

func _on_SpinBox_value_changed(value):
	Global.set_scaling(value)

func _on_StepSpinBox_value_changed(value):
	LevelGenerator.step_amount = value


func _on_WalkSpinBox_value_changed(value):
	LevelGenerator.walk_amount = value


func _on_CheckBox_toggled(button_pressed):
	LevelGenerator.enabled_smoothing = button_pressed


func _on_RoomX_value_changed(value):
	LevelGenerator.room_size = Vector2(value, LevelGenerator.room_size.y)


func _on_RoomY_value_changed(value):
	LevelGenerator.room_size = Vector2(LevelGenerator.room_size.x, value)


func _on_Button_pressed():
	LevelGenerator.generate_level(self)
