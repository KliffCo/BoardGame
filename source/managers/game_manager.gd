class_name GameManager
extends Node3D

static var main: GameManager = null

@export_file("*.tres") var _game_mode_files: Array[String]
var _game_modes: Array[GameMode] = []

func get_game_modes() -> Array[GameMode]:
	if _game_modes.size() == 0:
		for file in _game_mode_files:
			_game_modes.append(load(file))
	return _game_modes

func _ready() -> void:
	if main != null:
		return
	main = self
	DebugManager.main.on_ready()

func set_game_mode(hash: int) -> bool:
	for g in get_game_modes():
		if g.name.hash() == hash:
			g.init()
			if Lobby.main.is_host:
				DebugManager.main.on_game_mode()
			return true
	return false
