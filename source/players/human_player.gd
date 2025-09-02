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
