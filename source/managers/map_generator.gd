class_name MapGenerator
extends Resource

static func generate(s: MapSettings) -> void:
	var room_man:= RoomManager.main
	room_man.clear()
	var tile_set: FileOddsList = load(s.tile_set)
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	if s.map_seed == 0:
		rng.randomize()
	else:
		rng.set_seed(s.map_seed)
	
	var tile: RoomTile = load(tile_set.get_random(rng)).instantiate()
	var _room0 := room_man.try_add_room(tile, Vector2i.ZERO, true)

	while room_man.count() < s.rooms:
		var room_id: int = min(rng.randi() % (int)(room_man.count() * s.extend_odds), room_man.count()-1)
		var src_room: Room = room_man.get_room(room_id)
		if src_room.unused_exits.size() == 0:
			continue
		var exit_id: int = rng.randi() % src_room.unused_exits.size()
		var exit: RoomExit = src_room.unused_exits[exit_id]
		var exit_pos: Vector2i = exit.position
		var entry_pos: Vector2i = exit_pos + exit.direction
		var dst_room: Room = room_man.room_at_pos(entry_pos)
		if dst_room != null:
			room_man.try_connect_rooms(src_room, exit_pos, dst_room, entry_pos)
		else:
			tile = load(tile_set.get_random(rng)).instantiate()
			dst_room = room_man.try_add_room(tile, entry_pos, false)
			if dst_room == null:
				continue
			if not room_man.try_connect_rooms(src_room, exit_pos, dst_room, entry_pos):
				room_man.remove_last_room()
