class_name GameControl
extends Node3D

static var main: GameControl
@export_file("*.tres") var _level: String

func _ready() -> void:
	if main != null:
		return
	main = self
	
	if _level:
		RoomManager.main.load(_level)
