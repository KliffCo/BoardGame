class_name RoomManager
extends Node3D

static var main: RoomManager = null

func _ready() -> void:
	main = self
	
func clear():
	for child in get_children():
		child.queue_free()

func load(file: String):
	var settings: MapSettings = load(file)
	MapGenerator.generate(settings)
