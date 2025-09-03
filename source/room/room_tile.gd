@tool
class_name RoomTile
extends Node3D

#@export_subgroup("Model")
@export_file("*.gltf") var file: String
#@export_subgroup("Shape")
@export var size: Vector2i = Vector2i.ONE

@export var exits: Array[RoomExit] = []:
	set(new_value):
		for i in range(new_value.size()):
			if new_value[i] is not RoomExit:
				new_value[i] = _new_room_exit(i)
		exits = new_value

func _max_exit_count() -> int:
	return 1

func _new_room_exit(index: int) -> RoomExit:
	return RoomExit.new()
