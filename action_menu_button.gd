class_name ActionMenuButton
extends Control

var _chr: Char
var _act: ActionSelectable

func setup(chr: Char, act: ActionSelectable):
	_chr = chr
	_act = act
	var btn = find_child("button", false, false)
	btn.text = act.action.name

func _on_button_up() -> void:
	ActionMenu.main.hide_list()
	_chr.invoke_action(_act)
