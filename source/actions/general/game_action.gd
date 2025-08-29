class_name GameAction
extends Resource

@export var name: String
@export var advanced: bool

func get_selectables(_con: Controllable) -> Array[ActionSelectable]:
	return []

func invoke(_con: Controllable, _act: ActionSelectable) -> void:
	pass
