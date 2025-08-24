class_name Selectable
extends Node3D

var _is_selectable: bool
var _selectable_color: Color
var _selectable_alpha: float
var _current_color := Color.TRANSPARENT
var _is_color_changing: bool = false

var is_selectable: bool:
	get:
		return _is_selectable
	set(value):
		_is_selectable = value
		if value == false:
			_selectable_alpha = 0.0
		else:
			_current_color = Color(_selectable_color, _current_color.a)
		_is_color_changing = true

func set_selectable_color(color: Color) -> void:
	_selectable_alpha = 1.0
	_selectable_color = color
	_is_color_changing = true

func set_selectable_alpha(alpha) -> void:
	_selectable_alpha = alpha
	_is_color_changing = true

func _process(delta: float) -> void:
	_process_color(delta)

func _process_color(delta: float) -> void:
	if not _is_color_changing:
		return
	var _desired_color := Color(_selectable_color, _selectable_color.a * _selectable_alpha)
	_current_color = _current_color.lerp(_desired_color, delta)
	var diff_color := _current_color - _desired_color
	var diff_sq := diff_color.a*diff_color.a + diff_color.r*diff_color.r + diff_color.g*diff_color.g + diff_color.b*diff_color.b
	if(diff_sq < 0.01):
		_is_color_changing = false
		_current_color = _desired_color
	_selectable_update()

func _selectable_update() -> void:
	pass
