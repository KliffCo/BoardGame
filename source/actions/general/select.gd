class_name ActionSelect
extends GameAction

func default_name() -> String:
	return "Select"

func get_selectables(_con: Controllable) -> Array[ActionSelectable]:
	return []

func invoke(_con: Controllable, act: ActionSelectable) -> void:
	InputManager.main.set_controlling(act.selectable as Controllable)
