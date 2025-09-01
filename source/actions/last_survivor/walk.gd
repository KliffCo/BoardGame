class_name LSActionWalk
extends GameAction

@export var _min:= 1
@export var _max:= 1

func _property_can_revert(property: StringName) -> bool:
	if property == "name":
		return true
	return false

func _property_get_revert(property: StringName) -> Variant:
	if property == "name":
		return "Walk"
	return null
	#return super._property_get_revert(property)

func get_color() -> Color:
	return Colors.ROOM_WALKABLE if advanced else Colors.ROOM_WALKABLE

func get_selectables(con: Controllable) -> Array[ActionSelectable]:
	var chr = con as Char
	if not chr:
		return []
	var list : Array[ActionSelectable] = []
	var rooms := RoomManager.main.rooms
	var start = chr.room.id
	var distances := RoomManager.main.get_distance_array(start, _max)
	var __max : int = max(_max, RoomManager.main.rooms.size()-1)
	for i in range(rooms.size()):
		var room := rooms[i]
		var distance := distances[i]
		if distance <= __max and distance >= _min and room.has_empty_slot():
			var action_sel := ActionSelectable.new(room, self, Colors.ROOM_WALKABLE)
			list.append(action_sel);
	return list

func invoke(con: Controllable, act: ActionSelectable) -> void:
	var chr = con as Char
	if not chr:
		return
	var room := act.selectable as Room
	var slot := room.get_closest_slot(chr.slot.global_position)
	if slot:
		GameMode.main.do_action(con, func(callback: Callable):
			chr.slot = slot
			var points: Array[Vector3] = []
			points.append(slot.global_position)
			chr.walk_to(points, callback)
		)
