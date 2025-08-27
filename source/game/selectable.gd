class_name Selectable
extends Node3D

var _is_stroked: bool = false
var _is_filled: bool = false
var _desired_stroke:= Color.TRANSPARENT
var _current_stroke:= Color.TRANSPARENT
var _desired_fill:= Color.TRANSPARENT
var _current_fill:= Color.TRANSPARENT
var _is_color_changing: bool = false
var _collider: PhysicsBody3D = null

var collider: PhysicsBody3D:
	get: return _collider

func set_stroke(enabled: bool, color: Color) -> void:
	if enabled:
		_desired_stroke = color
		if not _is_stroked && not _is_color_changing:
			_current_stroke = Color(_desired_stroke, _current_stroke.a)
	else:
		_desired_stroke = Color(_current_stroke, 0.0)
	_is_stroked = enabled
	_is_color_changing = true

func set_fill(enabled: bool, color: Color) -> void:
	if enabled:
		_desired_fill = color
		if not _is_filled && not _is_color_changing:
			_current_fill = Color(_desired_fill, _current_fill.a)
		_is_color_changing = true
	else:
		_desired_fill = Color(_current_fill, 0.0)
	_is_filled = enabled
	_is_color_changing = true

func become_desired_color() -> void:
	_is_color_changing = false
	_current_stroke = _desired_stroke
	_current_fill = _desired_fill
	_selectable_update()

func _process(delta: float) -> void:
	_process_color(delta)

func _process_color(delta: float) -> void:
	if not _is_color_changing:
		return
	_current_stroke = _current_stroke.lerp(_desired_stroke, delta * 10.0)
	var stroke_diff := Vector4(_current_stroke.r-_desired_stroke.r, _current_stroke.g-_desired_stroke.g, _current_stroke.b-_desired_stroke.b, _current_stroke.a-_desired_stroke.a)
	_current_fill = _current_fill.lerp(_desired_fill, delta * 10.0)
	var fill_diff := Vector4(_current_fill.r-_desired_fill.r, _current_fill.g-_desired_fill.g, _current_fill.b-_desired_fill.b, _current_fill.a-_desired_fill.a)
	if(stroke_diff.length_squared() < 0.001 && fill_diff.length_squared() < 0.001):
		become_desired_color()
	else:
		_selectable_update()

func _selectable_update() -> void:
	pass
