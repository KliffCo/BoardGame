class_name Room
extends Node

var room_tile: RoomTile
#var grid_pos: Array[Vector2i] = []
var grid_list: Array[Vector2i] = []
var exit_list: Array[int] = []

var grid_pos: Vector2i:
	get:
		return grid_list[0]

func _init(room_tile: RoomTile, pos: Vector2i):
	self.room_tile = room_tile
	grid_list.append(pos)
	add_child(room_tile)
