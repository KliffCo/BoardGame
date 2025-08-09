class_name GameControl
extends Node3D

static var main: GameControl
@export_file("*.tres") var _level: String
var game_mode: GameMode

func _ready() -> void:
	if main != null:
		return
	main = self
	game_mode = GameModeLastSurvivor.new()
	
	if _level:
		RoomManager.main.load(_level)
