class_name GameControl
extends Node3D

static var main: GameControl
@export_file("*.tres") var _level: String

func _ready() -> void:
	if main != null:
		return
	main = self
	
	if _level:
		var settings: MapSettings = load(_level)
		RoomManager.main.load(settings)

#func _init_map():
	#for child in get_parent().get_children():
		#if child is MapGenerator:
			#return
