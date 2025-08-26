class_name Selectable
extends Node3D

var _is_outlined: bool = false
var _is_filled: bool = false
var _desired_outline:= Color.TRANSPARENT
var _current_outline:= Color.TRANSPARENT
var _desired_fill:= Color.TRANSPARENT
var _current_fill:= Color.TRANSPARENT
var _is_color_changing: bool = false
var _collider: PhysicsBody3D = null

var collider: PhysicsBody3D:
	get: return _collider

var is_outlined: bool:
	set(value): set_is_outlined(value)
var is_filled: bool:
	set(value): set_is_filled(value)
var outline_color: Color:
	set(value): set_outline_color(value)
var fill_color: Color:
	set(value): set_fill_color(value)

func set_is_outlined(value: bool):
	_is_outlined = value
	_is_color_changing = true
	if not _is_outlined:
		_desired_outline = Color(_current_outline, 0.0)

func set_is_filled(value: bool):
	_is_filled = value
	_is_color_changing = true

func set_outline_color(value: Color) -> void:
	_desired_outline = value
	if _is_outlined == false && not _is_color_changing:
		_current_outline = Color(_desired_outline, _current_outline.a)
	_is_color_changing = true

func set_fill_color(value: Color) -> void:
	_desired_fill = value
	if _is_outlined == false && not _is_color_changing:
		_current_fill = Color(_desired_fill, _current_fill.a)
	_is_color_changing = true

func copy_state(src: Selectable):
	_is_outlined = src._is_outlined
	_is_filled = src._is_filled
	_desired_outline = src._desired_outline
	_current_outline = src._current_outline
	_desired_fill = src._desired_fill
	_current_fill = src._current_fill
	_is_color_changing = src._is_color_changing
	_selectable_update()

func set_desired_color():
	_is_color_changing = false
	_current_outline = _desired_outline
	_current_fill = _desired_fill
	_selectable_update()

func _process(delta: float) -> void:
	_process_color(delta)

func _process_color(delta: float) -> void:
	if not _is_color_changing:
		return
	_current_outline = _current_outline.lerp(_desired_outline, delta * 10.0)
	var outline_diff := Vector4(_current_outline.r-_desired_outline.r, _current_outline.g-_desired_outline.g, _current_outline.b-_desired_outline.b, _current_outline.a-_desired_outline.a)
	_current_fill = _current_fill.lerp(_desired_fill, delta * 10.0)
	var fill_diff := Vector4(_current_fill.r-_desired_fill.r, _current_fill.g-_desired_fill.g, _current_fill.b-_desired_fill.b, _current_fill.a-_desired_fill.a)
	if(outline_diff.length_squared() < 0.001 && fill_diff.length_squared() < 0.001):
		set_desired_color()
	else:
		_selectable_update()

func _selectable_update() -> void:
	pass
