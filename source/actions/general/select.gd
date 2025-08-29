class_name LSActionSelect
extends GameAction

func get_selectables(con: Controllable) -> Array[ActionSelectable]:
	return []

func invoke(con: Controllable, act: ActionSelectable) -> void:
	InputManager.main.set_controlling(act.selectable as Controllable)
