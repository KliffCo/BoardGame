class_name RoomManager
extends Node3D

static var main: RoomManager = null

var rooms: Array[Room] = []
var min_range: Vector2
var max_range: Vector2
var mid_pos: Vector3
var radius: float

func _ready() -> void:
	main = self

func clear():
	min_range = Vector2.ZERO
	max_range = Vector2.ZERO
	for room in rooms:
		room.free()
	rooms = []

func get_room_count() -> int:
	return rooms.size()

func load(file: String):
	var settings: MapSettings = load(file)
	MapGenerator.generate(settings)
	update_range()
	GameMode.main.on_map_loaded()

func add_room(room: Room):
	rooms.append(room)
	add_child(room)

func get_room(index: int):
	return rooms[index]

func remove_room_at(index: int):
	var room = rooms[index]
	rooms.remove_at(index)
	room.free()

func remove_room(room: Room):
	remove_room_at(rooms.find(room))

func find_room_at_pos(pos: Vector2i) -> int:
	for i in range(rooms.size()):
		if rooms[i].is_in_grid(pos):
			return i
	return -1

func get_room_at_pos(pos: Vector2i) -> Room:
	for r in rooms:
		if r.is_in_grid(pos):
			return r
	return null

func try_add_room(data: RoomTile, pos: Vector2i, build_model: bool) -> Room:
	var room = Room.new(RoomManager.main.get_room_count(), data, pos)
	for g in room.grid_list:
		if get_room_at_pos(g):
			data.free()
			room.free()
			return null
	add_room(room)
	if build_model:
		room.build_model()
	return room

func update_range():
	var min:= Vector2.ZERO
	var max:= Vector2.ZERO
	for room in rooms:
		for g in room.grid_list:
			min = min.min(g)
			max = max.max(g)
	mid_pos = Vector3(min.x+max.x, 0, min.y+max.y)/2 + Vector3(0, 0, 1)
	radius = max(max.x-min.x, max.y+min.y)/2 + 1
	#min_range = Vector3(min.x-1, 0, min.y-1)
	#max_range = Vector3(max.x+1, 0, max.y+1)
