class_name GameAction
extends Resource

@export var _name: String
@export var advanced: bool

func action_name() -> String:
	return _name if _name else default_name()

func default_name() -> String:
	return "Action"

func get_selectables(_con: Controllable) -> Array[ActionSelectable]:
	return []

func invoke(_con: Controllable, _act: ActionSelectable) -> void:
	pass
