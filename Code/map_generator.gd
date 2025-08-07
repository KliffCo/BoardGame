@tool
class_name MapGenerator
extends Node3D

@export_file("*.tscn") var _room_set: String
#@export var room_set: RoomSet
@export var _seed: int
@export var _rooms: int = 10
@export_range(1, 10) var _extend_odds: float = 1
@export var _holder: Node3D
@export_tool_button("Generate") var btn_generate: Callable = generate

func _ready() -> void:
	generate()

func try_add_room(tile: Tile, pos: Vector2i, rooms: Array[Room]) -> Room:
	#if grid.find(pos) != -1:
		#tile.free()
		#return null
	var room = Room.new(tile, pos)
	rooms.append(room)
	_holder.add_child(room)
	return room

func find_room_at_pos(pos: Vector2i, rooms: Array[Room]) -> Room:
	for r in rooms:
		if r.grid_list.find(pos) != -1:
			return r
	#if grid.find(pos) != -1:
	return null

func generate():
	clear()
	var room_set: RoomSet = load(_room_set).instantiate()
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.set_seed(_seed)
	
	var rooms: Array[Room] = []
	var tile: Tile = room_set.get_random_tile(rng)
	try_add_room(tile, Vector2i.ZERO, rooms)
	
	if rooms.size() < _rooms:
		var room_id: int = min(rng.randi() % (int)(rooms.size() * _extend_odds), rooms.size()-1)
		var src_room: Room = rooms[room_id]
		if src_room.unused_exits.size() == 0:
			return #### continue
		var exit_id: int = rng.randi() % (src_room.unused_exits.size()-1)
		var exit: RoomExit = src_room.unused_exits[exit_id]
		var exit_pos: Vector2i = src_room.grid_pos + exit.position
		var entry_pos: Vector2i = exit_pos + exit.direction
		#if grid.find(pos):
			#return false
		var dst_room: Room = find_room_at_pos(entry_pos, rooms)
		if dst_room != null:
			try_connect_rooms(src_room, exit_pos, dst_room, entry_pos)
		else:
			tile = room_set.get_random_tile(rng)
			dst_room = try_add_room(tile, entry_pos, rooms)
			if dst_room == null:
				return #### continue
			if not try_connect_rooms(src_room, exit_pos, dst_room, entry_pos):
				rooms.remove_at(rooms.find(dst_room))
				dst_room.free()

func try_connect_rooms(a_room: Room, a_pos: Vector2i, b_room: Room, b_pos: Vector2i):
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

func clear():
	for child in _holder.get_children():
		child.queue_free()
