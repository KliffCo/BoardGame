@tool
class_name MapGenerator
extends Node

@export_file("*.tscn") var _room_set: String
#@export var room_set: RoomSet
@export var _seed: int
@export var _rooms: int = 10
@export_range(1, 10) var _extend_odds: float = 1
@export var _holder: Node3D
@export_tool_button("Generate")
var _btn_generate: Callable = generate

class RoomLinks:
	var room: Room
	var exits: Array[Vector2i] = []
	func _init(room: Room):
		self.room = room
		for i in room.room_tile.exits.size():
			self.exits.append(i)
		#self.exits.append_array(room.exits)

func _ready() -> void:
	generate()

func try_add_room(room_tile: RoomTile, pos: Vector2i, rooms: Array[Room], links: Array[RoomLinks]) -> Room:
	#if grid.find(pos) != -1:
		#room_tile.free()
		#return null
	var room = Room.new(room_tile, pos)
	rooms.append(room)
	_holder.add_child(room)
	links.append(RoomLinks.new(room))
	#grid.append(pos)
	return room

func find_room_at_pos(pos: Vector2i, rooms: Array[Room]) -> Room:
	for r in rooms:
		if r.grid_list.find(pos) != -1:
			return r
	#if grid.find(pos) != -1:
	return null

func generate():
	clear()
	var room_set: RoomSet = load(_room_set).instantiate()
	var rng = RandomNumberGenerator.new()
	rng.set_seed(_seed)
	
	var rooms: Array[Room] = []
	var links: Array[RoomLinks] = []
	#var grid: Array[Vector2i] = []
	var room_tile: RoomTile = room_set.get_random_room(rng)
	try_add_room(room_tile, Vector2i.ZERO, rooms, links)
	
	if rooms.size() < _rooms:
		var link_id = min(rng.randi() % (int)(links.size() * _extend_odds), links.size()-1)
		var link: RoomLinks = links[link_id]
		var exit_id = rng.randi() % (link.exits.size()-1)
		var exit_offset: Vector2i = link.exits[exit_id]
		var new_pos: Vector2i = link.room.grid_pos + exit_offset
		#if grid.find(pos):
			#return false
		var room: Room = find_room_at_pos(new_pos, rooms)
		if room != null:
			try_connect_rooms(link.room, room, exit_offset)
		else:
			room_tile = room_set.get_random_room(rng)
			if try_add_room(room_tile, new_pos, rooms, links):
				link.exits.remove_at(exit_id)
				if link.exits.size() == 0:
					links.remove_at(link_id)

func try_connect_rooms(a: Room, b: Room, a_offset: Vector2i):
	var b_offset: Vector2i = Vector2i(-a_offset.x, -a_offset.y)
	var b_index = b.room_tile.exits.find(b_offset)
	if b_index == -1:
		return false
	#b.exit_list.append(b_index)
	b.exits
	return true

func clear():
	for child in _holder.get_children():
		child.queue_free()
