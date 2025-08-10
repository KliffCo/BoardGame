class_name MapGenerator
extends Resource

static func generate(s: MapSettings):
	var room_man:= RoomManager.main
	room_man.clear()
	var tile_set: RoomTileSet = load(s.tile_set)
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	if s.map_seed == 0:
		rng.randomize()
	else:
		rng.set_seed(s.map_seed)
	
	#var rooms: Array[Room] = []
	#var rooms: Array[Room] = RoomManager.main.rooms
	var data: RoomTile = tile_set.get_random_room_data(rng)
	room_man.try_add_room(data, Vector2i.ZERO, true)
	
	while room_man.get_room_count() < s.rooms:
		var room_id: int = min(rng.randi() % (int)(room_man.get_room_count() * s.extend_odds), room_man.get_room_count()-1)
		var src_room: Room = room_man.get_room(room_id)
		if src_room.unused_exits.size() == 0:
			continue
		var exit_id: int = rng.randi() % src_room.unused_exits.size()
		var exit: RoomExit = src_room.unused_exits[exit_id]
		var exit_pos: Vector2i = exit.position
		var entry_pos: Vector2i = exit_pos + exit.direction
		var dst_room: Room = room_man.get_room_at_pos(entry_pos)
		if dst_room != null:
			try_connect_rooms(src_room, exit_pos, dst_room, entry_pos)
		else:
			data = tile_set.get_random_room_data(rng)
			dst_room = room_man.try_add_room(data, entry_pos, false)
			if dst_room == null:
				continue
			if not try_connect_rooms(src_room, exit_pos, dst_room, entry_pos):
				room_man.remove_room(dst_room)

static func try_connect_rooms(a_room: Room, a_pos: Vector2i, b_room: Room, b_pos: Vector2i):
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
