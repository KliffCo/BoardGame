class_name ActionSelect
extends GameAction

func _init() -> void:
	name = "Select"

func get_selectables(_con: Controllable) -> Array[ActionSelectable]:
	return []

func invoke(_con: Controllable, act: ActionSelectable) -> void:
	InputManager.main.set_controlling(act.selectable as Controllable)
