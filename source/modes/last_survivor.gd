class_name GameModeLastSurvivor
extends GameMode

@export_file("*.tres") var _char_set_file: String
@export var _map_settings: MapSettings

func load_map() -> void:
	RoomManager.main.load(_map_settings)

func map_loaded() -> void:
	var room_man := RoomManager.main
	var char_man := CharManager.main
	var char_set: FileOddsList = load(_char_set_file)
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()
	for i in range(room_man.count()):
		var room := room_man.get_room(i)
		var empty_slots = room.get_empty_slots()
		if empty_slots.size() > 0:
			var data: CharData = load(char_set.get_random(rng))
			char_man.new_char(data, empty_slots[0])
	PlayerManager.main.first_player()

func turn_finished() -> void:
	PlayerManager.main.next_player()
	try_shrink_map()

func try_shrink_map() -> void:
	var alive_count = CharManager.main.count_alive()
	if alive_count > 0 and alive_count <= 3:
		var alive := CharManager.main.get_alive_list()
		var rooms := RoomManager.main.rooms
		var start_id := alive[0].room.id
		var distances := RoomManager.main.get_distance_array(start_id, RoomManager.MAX_ROOMS, 0)
		#var empty: Array[bool] = []
		#empty.resize(rooms.size())
		var choices: Array[int] = []
		for i in range(rooms.size()):
			#empty[i] = rooms[i].is_empty()
			if rooms[i].is_empty():
				choices.append((distances[i] << 16) + i)
		choices.sort()
		for i in range(choices.size()-1, -1, -1):
			var room_id := choices[i] & 0xFFFF;
			var path:= RoomManager.main.find_path2(room_id, start_id, distances)
			if path.size() != 0:
				return
		#var pick = choices[_rng.randi() % choices.size()]
	return

#, path: Array[int], exits: Array[int]


func on_char_died() -> void:
	var count:= CharManager.main.count_alive()
	if count <= 1:
		end_game()
