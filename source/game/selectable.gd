class_name Selectable
extends Node3D

var _is_selected: bool
var _is_selectable: bool
var _selectable_color: Color

func set_selected(value: bool) -> void:
	_is_selected = value
	_update_selectable()

func set_selectable(color) -> void:
	if _is_selectable == (color is Color):
		return
	_is_selectable = color is Color
	if _is_selectable:
		_selectable_color = color
	_update_selectable()

func _update_selectable() -> void:
	pass
