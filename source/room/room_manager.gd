class_name RoomManager
extends Node3D

static var main: RoomManager = null
var min_range: Vector2
var max_range: Vector2
var mid_pos: Vector3
var radius: float

func _ready() -> void:
	main = self

func clear():
	min_range = Vector2.ZERO
	max_range = Vector2.ZERO
	for child in get_children():
		child.queue_free()

func load(file: String):
	var settings: MapSettings = load(file)
	MapGenerator.generate(settings)
	update_range()
	GameMode.main.on_map_loaded()

func update_range():
	var min: Vector2
	var max: Vector2
	for c in get_children():
		if c is Room:
			for g in c.grid_list:
				min = min.min(g)
				max = max.max(g)
	mid_pos = Vector3(min.x+max.x, 0, min.y+max.y)/2 + Vector3(0, 0, 1)
	radius = max(max.x-min.x, max.y+min.y)/2 + 1
	#min_range = Vector3(min.x-1, 0, min.y-1)
	#max_range = Vector3(max.x+1, 0, max.y+1)
