@tool
class_name Tile
extends Node3D

@export_subgroup("Model")
@export_file("*.fbx") var file: String

@export_subgroup("Shape")
@export var size: Vector2i = Vector2i.ONE
#@export var exits: Array[Vector2i] = []

@export var exits: Array[RoomExit] = []:
	set(new_value):
		for i in range(new_value.size()):
			if new_value[i] is not RoomExit:
				new_value[i] = RoomExit.new()
				new_value[i].init(i)
		exits = new_value
