class_name Player

var id: int
var name: String
var avatar: Texture2D

var _my_turn:= false

var my_turn: bool:
	get: return _my_turn
	set(value):
		if _my_turn != value:
			_my_turn = value

func turn_started() -> void:
	pass

func turn_finished() -> void:
	pass
