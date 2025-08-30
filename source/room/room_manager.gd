class_name RoomManager
extends Node3D

static var main: RoomManager = null
const MAX_ROOMS = 0xFFFF

@export_file("*.tres") var _outline_material_file: String
var _outline_material: ShaderMaterial

var rooms: Array[Room] = []
var min_range: Vector2
var max_range: Vector2
var mid_pos: Vector3
var radius: float

func _ready() -> void:
	main = self
	_outline_material = load(_outline_material_file) as ShaderMaterial
	_outline_material.set_shader_parameter("tex_albedo", null)
	#_outline_material.set_shader_parameter("outline_size", 2.0)

func new_outline_material() -> ShaderMaterial:
	return _outline_material.duplicate()

func clear() -> void:
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

func remove_last_room() -> void:
	var room = rooms[-1]
	rooms.remove_at(rooms.size()-1)
	room.free()

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
	var room = Room.new(rooms.size(), data, pos)
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

func get_distance_array_from_room(start: Room) -> Array[int]:
	return get_distance_array(start.id)

func get_distance_array(start: int, max_distance: int = MAX_ROOMS, min_empty_slots: int = 1, max_full_slots: int = MAX_ROOMS) -> PackedInt32Array:
	var _count = rooms.size()
	var distances := PackedInt32Array()
	distances.resize(_count)
	for i in range(_count):
		distances[i] = _count
	distances[start] = 0
	var to_do :Array[int] = []
	to_do.append(start)
	while to_do.size() != 0:
		var src_index := to_do[-1]
		to_do.remove_at(to_do.size()-1)
		var src := rooms[src_index]
		var distance := distances[src_index]+1
		if distance <= max_distance:
			for exit in src.exits:
				var dst = exit.room
				if distances[dst.id] > distance and distances[dst.id] <= _count:
					var empty_slots_count := dst.empty_slot_count()
					if empty_slots_count >= min_empty_slots and (dst.char_slots.size() - empty_slots_count) <= max_full_slots:
						distances[dst.id] = distance
						if dst.id not in to_do:
							to_do.append(dst.id)
					else:
						distances[dst.id] = MAX_ROOMS
	return distances

func find_path(start_index: int, end_index: int) -> Array[int]:
	var distances_from_end := get_distance_array(end_index)
	var path := find_path_with_distance_array(start_index, end_index, distances_from_end)
	return path

func find_path_with_distance_array(start_index: int, end_index: int, distances_from_end: PackedInt32Array) -> Array[int]:
	if distances_from_end[start_index] >= rooms.size():
		return []
	var path: Array[int] = [start_index]
	if start_index == end_index:
		return path
	var dist := distances_from_end[start_index] - 1
	var room := rooms[start_index]
	while dist != 0:
		for exit in room.exits:
			if distances_from_end[exit.room.id] == dist:
				room = exit.room
				path.append(room.id)
				dist -= 1
				break
	path.append(end_index)
	return path

#func find_path(start_index: int, end_index: int) -> Array[int]:
	#var distances:= get_distance_array(start_index)
	#if distances[end_index] >= rooms.size():
		#return []
	#var path: Array[int] = []
	#path.append(end_index)
	#var dist := distances[end_index] - 1
	#var room := rooms[end_index]
	#while dist != 0:
		#for exit in room.exits:
			#if distances[exit.room.id] == dist:
				#room = exit.room
				#path.append(room.id)
				#dist -= 1
				#break
	##path.append(start_pos)
	#path.reverse()
	#return path

func find_path2(start_index: int, end_index: int, distances_from_end: PackedInt32Array) -> Array[int]:
	var path: Array[int] = []
	var current_exits: Array[int] = []
	var exits_orders: Array[PackedInt32Array] = []
	var tested: Array = []
	
	exits_orders.resize(rooms.size())
	for i in range(rooms.size()):
		exits_orders[i].resize(rooms[i].exits.size())
		for j in range(rooms[i].exits.size()):
			exits_orders[i][j] = (distances_from_end[j] << 16) + j
		exits_orders[i].sort()
		for j in range(rooms[i].exits.size()):
			exits_orders[i][j] &= MAX_ROOMS
	
	tested.resize(rooms.size())
	tested[start_index] = true
	path.append(start_index)
	if start_index == end_index:
		return path
	current_exits.append(0)
	while path.size() > 0:
		var success:= false
		var r := path[-1]
		var room := rooms[r]
		for o in range(current_exits[r], room.exits.size()):
			current_exits[-1] = o+1
			var exit := room.exits[exits_orders[r][o]]
			var er = exit.room.id
			if not tested[er]:
				if er == end_index:
					path.append(end_index)
					return path
				tested[er] = true
				var can_enter = exit.room.is_empty()
				if can_enter:
					path.append(er)
					current_exits.append(0)
					success = true
					break
		if not success:
			path.remove_at(path.size()-1)
			current_exits.remove_at(current_exits.size()-1)
	return path
