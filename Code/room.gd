class_name Room
extends Node3D

var tile: Tile
var grid_list: Array[Vector2i] = []
var exits: Array[RoomExit] = []
var unused_exits: Array[RoomExit] = []

var grid_pos: Vector2i:
	get:
		return grid_list[0]

func _init(tile: Tile, pos: Vector2i):
	self.tile = tile
	grid_list.append(pos)
	position = Vector3i(pos.x, 0, pos.y)
	add_child(tile)
	set_angle(0)

func set_angle(angle: int):
	exits = []
	unused_exits = []
	for src in tile.exits:
		var e = RoomExit.new()
		e.position = grid_pos + src.position
		e.direction = src.direction
		unused_exits.append(e)

func find_unused_exit(pos: Vector2i, dir: Vector2i) -> int:
	#for e in unused_exits:
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
