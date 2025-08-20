class_name GameModeLastSurvivor
extends GameMode

@export_file("*.tres") var _char_set_file: String
@export var _map_settings: MapSettings

func load_map():
	RoomManager.main.load(_map_settings)

func map_loaded():
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
	
