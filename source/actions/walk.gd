class_name GameActionWalk
extends GameAction

@export var min:= 1
@export var max:= 1

func get_color() -> Color:
	return Colors.ROOM_WALKABLE if advanced else Colors.ROOM_WALKABLE

func get_selectables(chr: Char) -> Array[ActionSelectable]:
	var list : Array[ActionSelectable] = []
	#var chr = CharManager.Singleton.SelectedCharacter
	var rooms := RoomManager.main.rooms
	var start = rooms.find(chr.room)
	var distances := RoomManager.main.get_distance_array(start)
	for i in range(rooms.size()):
		var distance = distances[i]
		if distance <= range && distance > 0 && rooms[i].has_empty_slot():
			var action_sel := ActionSelectable.new(rooms[i], self, Colors.ROOM_WALKABLE)
			list.append(action_sel);
	return list
