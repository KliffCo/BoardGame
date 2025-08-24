class_name LSActionWalk
extends GameAction

@export var min:= 1
@export var max:= 1

func get_color() -> Color:
	return Colors.ROOM_WALKABLE if advanced else Colors.ROOM_WALKABLE

func get_selectables(chr: Char) -> Array[ActionSelectable]:
	var list : Array[ActionSelectable] = []
	#var chr = CharManager.main.selected
	var rooms := RoomManager.main.rooms
	var start = rooms.find(chr.room)
	var distances := RoomManager.main.get_distance_array(start)
	for i in range(rooms.size()):
		var room := rooms[i]
		var distance := distances[i]
		if distance <= max && distance >= min && room.has_empty_slot():
			var action_sel := ActionSelectable.new(room, self, Colors.ROOM_WALKABLE)
			list.append(action_sel);
	return list

func invoke(_chr: Char, _other: Selectable) -> void:
	var room := _other as Room
	var slot := room.get_closest_slot(_chr.slot.global_position)
	if slot:
		GameMode.main.do_action(func(callback: Callable):
			_chr.slot = slot
			var points: Array[Vector3] = []
			points.append(slot.global_position)
			_chr.walk_to(points, callback)
		)
