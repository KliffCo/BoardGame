class_name GameManager
extends Node3D

static var main: GameManager
#@export var _game_mode: GameMode
#@export_file("*.tres") var _level: String
@export_file("*.tres") var _game_mode: String
var game_mode: GameMode

func _ready() -> void:
	if main != null:
		return
	add_child(load("res://game/ui/ui_manager.tscn").instantiate());
	main = self
	game_mode = load(_game_mode) as GameMode
	game_mode.load_map()
	
	#if _level:
		#RoomManager.main.load(_level)
