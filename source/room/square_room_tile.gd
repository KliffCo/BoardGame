@tool
class_name SquareRoomTile
extends RoomTile

func _max_exit_count() -> int:
	return 4

func _new_room_exit(index: int):
	var exit := RoomExit.new()
	exit.position = Vector2i.ZERO
	index %= _max_exit_count()
	if index == 0:
		exit.name = "N"
		exit.direction = Vector2i(0, -1)
	if index == 1:
		exit.name = "E"
		exit.direction = Vector2i(1, 0)
	if index == 2:
		exit.name = "S"
		exit.direction = Vector2i(0, 1)
	if index == 3:
		exit.name = "W"
		exit.direction = Vector2i(-1, 0)
	return exit
