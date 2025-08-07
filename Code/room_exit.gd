class_name RoomExit
extends Resource

@export var name: String
@export var position: Vector2i
@export var direction: Vector2i
var room: Room

func init(index: int):
	position = Vector2i.ZERO
	if index == 0:
		name = "N"
		direction = Vector2i(0, -1)
	if index == 1:
		name = "E"
		direction = Vector2i(1, 0)
	if index == 2:
		name = "S"
		direction = Vector2i(0, 1)
	if index == 3:
		name = "W"
		direction = Vector2i(-1, 0)
