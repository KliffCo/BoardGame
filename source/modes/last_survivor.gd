class_name GameModeLastSurvivor
extends GameMode

@export_file("*.tres") var _char_pool_file: String
var _char_pool: CharPool

func on_map_loaded():
	_char_pool = load(_char_pool_file)
	pass
