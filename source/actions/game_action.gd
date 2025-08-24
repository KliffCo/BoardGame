class_name GameAction
extends Resource

@export var name: String
@export var advanced: bool

#func get_color() -> Color:
#	return Color.WHITE

func get_selectables(_chr: Char) -> Array[ActionSelectable]:
	#var list : Array[Selectable] = []
	#return list
	return []

#func _can_select(sel: Selectable) -> bool:
	#return false
