class_name ActionSelect
extends GameAction

func _init():
	name = "Select"

func get_selectables(con: Controllable) -> Array[ActionSelectable]:
	return []

func invoke(con: Controllable, act: ActionSelectable) -> void:
	InputManager.main.set_controlling(act.selectable as Controllable)
