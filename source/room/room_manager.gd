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

func count() -> int:
	return rooms.size()

func load(settings: MapSettings) -> void:
	MapGenerator.generate(settings)
	update_range()
	if GameMode.main:
		GameMode.main.map_loaded()

func add_room(room: Room) -> void:
	rooms.append(room)
	add_child(room)

func get_room(index: int) -> Room:
	return rooms[index]

func remove_room_at(index: int) -> void:
	var room = rooms[index]
	rooms.remove_at(index)
	room.free()

func remove_room(room: Room) -> void:
	remove_room_at(rooms.find(room))

func find_room_at_pos(pos: Vector2i) -> int:
	for i in range(rooms.size()):
		if rooms[i].is_in_grid(pos):
			return i
	return -1

func room_at_pos(pos: Vector2i) -> Room:
	for r in rooms:
		if r.is_in_grid(pos):
			return r
	return null

func try_add_room(data: RoomTile, pos: Vector2i, build_model: bool) -> Room:
	var room = Room.new(count(), data, pos)
	for g in room.grid_list:
		if room_at_pos(g):
			data.free()
			room.free()
			return null
	add_room(room)
	if build_model:
		room.build_model()
	return room

func try_connect_rooms(a_room: Room, a_pos: Vector2i, b_room: Room, b_pos: Vector2i) -> bool:
	var b_dir = a_pos - b_pos
	var b_index = b_room.find_unused_exit(b_pos, b_dir)
	if b_index == -1:
		return false
	var a_dir = b_pos - a_pos
	var a_index = a_room.find_unused_exit(a_pos, a_dir)
	if a_index == -1:
		return false
	a_room.use_exit(a_index, b_room)
	b_room.use_exit(b_index, a_room)
	return true

func update_range() -> void:
	min_range = Vector2.ZERO
	max_range = Vector2.ZERO
	for room in rooms:
		for g in room.grid_list:
			min_range = min_range.min(g)
			max_range = max_range.max(g)
	mid_pos = Vector3(min_range.x+max_range.x, 0, min_range.y+max_range.y)/2 + Vector3(0, 0, 1)
	radius = (max_range-min_range).length()/2
