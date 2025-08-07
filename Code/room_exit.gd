class_name RoomExit
extends Resource

@export var position: Vector2i
@export var direction: Vector2i
var room: Room

func init(index: int):
	position = Vector2i.ZERO
	if index == 0:
		direction = Vector2i(0, -1)
	if index == 1:
		direction = Vector2i(1, 0)
	if index == 2:
		direction = Vector2i(0, 1)
	if index == 3:
		direction = Vector2i(-1, 0)
