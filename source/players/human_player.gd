class_name HumanPlayer
extends Player

var con: ServerCon = null

func _init() -> void:
	pass

func get_my_chars() -> Array[Char]:
	var list: Array[Char]
	for c in CharManager.main.chars:
		if c.player_id == id:
			list.append(c)
	return list

func send_new_char(chr: Char) -> void:
	con.send_new_char(chr)

func send_my_chars() -> void:
	con.send_my_chars()

func send_start_level() -> void:
	con.send_start_level()

func send_set_turn(id: int) -> void:
	con.send_set_turn(id)
