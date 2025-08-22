class_name InputManager
extends Node3D

static var main: InputManager

var _is_panning:= false
var _grip_position: Vector3
var _selectables:Array[ActionSelectable] = []

func _ready() -> void:
	main = self

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
			if e.pressed:
				var world_pos = CameraManager.main.screen_to_world_pos(e.position)
				if world_pos is Vector3:
					_is_panning = true
					_grip_position = world_pos
			else:
				_is_panning = false
		elif e.button_index == MOUSE_BUTTON_LEFT:
			if e.pressed:
				var hits: Array = CameraManager.main.colliders_at_screen_pos(e.position, Colliders.CHAR_MASK)
				var selected = false
				for hit in hits:
					var col = hit.collider as StaticBody3D
					var chr = col.get_parent_node_3d() as Char
					if chr && GameMode.main.on_select_char(chr):
						selected = true
						break
				if not selected:
					GameMode.main.on_select_char(null)
	elif e is InputEventMouseMotion:
		if _is_panning:
			var world_pos = CameraManager.main.screen_to_world_pos(e.position)
			if world_pos is Vector3:
				CameraManager.main.set_desired_pan(CameraManager.main.get_actual_pan()-world_pos+_grip_position)

func set_selectables(list: Array[ActionSelectable]):
	for sel:ActionSelectable in _selectables:
		sel.selectable.set_selectable(null)
	_selectables = list
	for sel:ActionSelectable in _selectables:
		sel.selectable.set_selectable(sel.color)
