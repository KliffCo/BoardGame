class_name Player

var id: int
var name: String
var avatar: Texture2D
var node: PlayerUI

var _my_turn:= false

var my_turn: bool:
	get: return _my_turn
	set(value):
		if _my_turn != value:
			_my_turn = value
			#if _my_turn:
				#turn_started()
			#else:
				#turn_ended()

func turn_started() -> void:
	node.set_active(true)

func turn_finished() -> void:
	node.set_active(false)
