class_name Selectable
extends Node3D

var _is_selectable: bool
var _desired_color: Color
var _current_color := Color.TRANSPARENT
var _is_color_changing: bool = false
#@onready var _collider = find_child("collider")

func get_collider() -> PhysicsBody3D:
	return null

func unset_selectable() -> void:
	_desired_color = Color(_current_color, 0.0)
	_is_selectable = false
	_is_color_changing = true

func set_selectable_color(color: Color) -> void:
	_desired_color = color
	if _is_selectable == false && not _is_color_changing:
		_current_color = Color(_desired_color, _current_color.a)
	_is_selectable = true
	_is_color_changing = true

func _process(delta: float) -> void:
	_process_color(delta)

func _process_color(delta: float) -> void:
	if not _is_color_changing:
		return
	_current_color = _current_color.lerp(_desired_color, delta * 10.0)
	var color_diff := Vector4(_current_color.r-_desired_color.r, _current_color.g-_desired_color.g, _current_color.b-_desired_color.b, _current_color.a-_desired_color.a)
	if(color_diff.length_squared() < 0.001):
		_is_color_changing = false
		_current_color = _desired_color
	_selectable_update()

func _selectable_update() -> void:
	pass
