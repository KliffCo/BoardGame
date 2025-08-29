class_name Controllable
extends Selectable

func get_selectables() -> Array[ActionSelectable]:
	return []

func set_controlling(_value: bool) -> void:
	pass

func invoke_action(act: ActionSelectable) -> void:
	act.action.invoke(self, act)
