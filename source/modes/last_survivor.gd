class_name GameModeLastSurvivor
extends GameModePlayerTurn

@export_file("*.tres") var _char_set_file: String
#@export_file("*.tscn") var _your_chars_popup_file: String
@export var _map_settings: MapSettings

func init() -> void:
	CharManager.main.append_char_set(_char_set_file)

func has_bots() -> bool:
	return false

func new_bot() -> BotPlayer:
	return LastSurvivorBot.new()

#func load_char(char_set: FileOddsList, pos: int) -> CharData:
	#var data: CharData = load(char_set.file_at(pos))
	#data.id = pos
	#char_man.new_char(data, empty_slots[0])

func start_game() -> void:
	super.start_game()
	load_map()

func load_map() -> void:
	RoomManager.main.load(_map_settings)
	add_chars_to_rooms();
	assign_chars()
	start_level()

func add_chars_to_rooms() -> void:
	var room_man := RoomManager.main
	var char_man := CharManager.main
	var char_set: FileOddsList = char_man.get_char_set(0)
	var char_set2: FileOddsList = char_set.duplicate(true)
	var char_set3: FileOddsList = char_set.duplicate(false)
	char_set2._list.remove_at(1)
	char_set3._list.remove_at(0)
	
	var order : Array[int] = random_int_list(char_man.get_char_set(0).size())
	for i in range(room_man.count()):
		var room := room_man.get_room(i)
		var empty_slots = room.get_empty_slots()
		if empty_slots.size() > 0:
			char_man.new_char(0, order[i%order.size()], empty_slots[0])

func assign_chars() -> void:
	var chars := CharManager.main.chars
	var players := Lobby.main.players
	var chars_per_player := 1
	var order : Array[int] = random_int_list(chars.size())
	var c := 0
	for p in players:
		for i in chars_per_player:
			chars[order[c]].player_id = p.id
			c += 1
	Lobby.main.send_my_chars()

func on_start_level() -> void:
	super.on_start_level()
	LSInterface.main.show_my_chars()
	#var _popup: Resource = load(_your_chars_popup_file)
	#var popup: LSYourCharsPopup = _popup.instantiate()
	#UIManager.main.add_child(popup)

func turn_finished() -> void:
	try_shrink_map()
	super.turn_finished()

func try_shrink_map() -> void:
	var alive := CharManager.main.get_alive_list()
	if alive.size() > 0 and alive.size() <= 3:
		for i in range(alive.size() - 1, 0, -1):
			var j = _rng.randi() % (i + 1)
			var temp := alive[i]
			alive[i] = alive[j]
			alive[j] = temp
		
		var rooms := RoomManager.main.rooms
		var distances : Array[int] = []
		distances.resize(rooms.size())
		var used_rooms : Array[bool] = []
		used_rooms.resize(rooms.size())
		
		for i in range(alive.size()):
			var chr1 := alive[i]
			var distances_to_chr1 := RoomManager.main.get_distance_array(chr1.room.id, RoomManager.MAX_ROOMS, 0)
			for j in range(i):
				var chr2 := alive[j]
				var path := RoomManager.main.find_path_with_distance_array(chr2.room.id, chr1.room.id, distances_to_chr1)
				var chr_dist := distances_to_chr1[chr2.room.id]
				for k in range(rooms.size()):
					if used_rooms[k] and distances_to_chr1[k] <= chr_dist:
						path = RoomManager.main.find_path_with_distance_array(k, chr1.room.id, distances_to_chr1)
						break
				for room_id in path:
					used_rooms[room_id] = true
			for k in range(rooms.size()):
				if not used_rooms[k] and rooms[k].exits.size() != 0:
					distances[k] += distances_to_chr1[k] * distances_to_chr1[k]
		
		var choice := -1
		for k in range(rooms.size()):
			if rooms[k].exits.size() != 0 and not used_rooms[k] and (choice == -1 or distances[k] >= distances[choice]):
				choice = k
		if choice != -1:
			rooms[choice].remove_all_exits()
			rooms[choice].visible = false
	return

func on_char_died() -> void:
	var count:= CharManager.main.count_alive()
	if count <= 1:
		end_game()
