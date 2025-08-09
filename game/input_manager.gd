class_name InputManager
extends Node3D

static var main: InputManager

var _is_panning:= false
var _grip_position: Vector3

func _ready() -> void:
	main = self

#func _process(delta: float) -> void:

func _input(e: InputEvent) -> void:
	if e is InputEventMouse:
		mouse_input(e)

func mouse_input(e: InputEventMouse):
	if e is InputEventMouseButton:
		if e.button_index == MOUSE_BUTTON_WHEEL_UP:
			CameraManager.main.set_desired_zoom(CameraManager.main.get_desired_zoom()+0.1)
		elif e.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			CameraManager.main.set_desired_zoom(CameraManager.main.get_desired_zoom()-0.1)
		elif e.button_index == MOUSE_BUTTON_RIGHT or e.button_index == MOUSE_BUTTON_MIDDLE:
			_is_panning = e.pressed
			if e.pressed:
				_grip_position = CameraManager.main.screen_to_world_pos(e.position)
				#var b = CameraManager.main.world_to_screen_pos(a)
	elif e is InputEventMouseMotion:
		if _is_panning:
			var world_pos = CameraManager.main.screen_to_world_pos(e.position)
			CameraManager.main.set_desired_pan(CameraManager.main.get_actual_pan()-world_pos+_grip_position)
			pass
		pass
