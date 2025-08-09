class_name Room
extends Node3D

static var _char_slot_prefab = preload("res://rooms/components/room_char_slot.tscn")

var _tile: RoomTile
var grid_list: Array[Vector2i] = []

var exits: Array[RoomExit] = []
var unused_exits: Array[RoomExit] = []

var _model: Node3D = null

var _char_slot_holder: Node3D = null
var _char_slots: Array[RoomCharSlot] = []

var grid_pos: Vector2i:
	get: return grid_list[0]

func _init(index:int, tile: RoomTile, pos: Vector2i):
	name = "Room"+str(index)
	_tile = tile
	grid_list.append(pos)
	position = Vector3i(pos.x, 0, pos.y)
	add_child(tile)
	set_angle(0)

func set_angle(angle: int):
	exits = []
	unused_exits = []
	for src in _tile.exits:
		var e = RoomExit.new()
		e.name = src.name
		e.position = grid_pos + src.position
		e.direction = src.direction
		unused_exits.append(e)

func build_model():
	if _tile.get_child_count() > 0:
		_model = _tile.get_child(0)
	else:
		pass # todo build fbx
	_init_char_slots()

func _init_char_slots():
	_char_slot_holder = Node3D.new()
	add_child(_char_slot_holder)
	for c in _model.get_children(false):
		if c.name.begins_with("CharSlot_"):
			var slot: RoomCharSlot = _char_slot_prefab.instantiate()
			_char_slots.append(slot)
			slot.position = c.position + Vector3(0, 0.01, 0)
			add_child(slot)

func find_unused_exit(pos: Vector2i, dir: Vector2i) -> int:
	for i in range(unused_exits.size()):
		var e = unused_exits[i]
		if e.position == pos and e.direction == dir:
			return i
	return -1

func use_exit(index: int, room: Room):
	var exit = unused_exits[index]
	exit.room = room
	exits.append(exit)
	unused_exits.remove_at(index)
	if _model == null:
		build_model()
	var nodes: Array[Node] = _model.find_children("Wall"+exit.name+"_*", "", false, false)
	for n in nodes:
		n.visible = false

func is_in_grid(pos: Vector2i) -> bool:
	return grid_list.find(pos) != -1
