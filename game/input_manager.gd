class_name InputManager
extends Node3D

static var main: InputManager

func _ready() -> void:
	main = self

#func _process(delta: float) -> void:

func _input(e: InputEvent) -> void:
	if e is InputEventMouseButton:
		if e.button_index == MOUSE_BUTTON_WHEEL_UP:
			CameraManager.main.set_desired_zoom(CameraManager.main.get_desired_zoom()+0.1)
		elif e.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			CameraManager.main.set_desired_zoom(CameraManager.main.get_desired_zoom()-0.1)
