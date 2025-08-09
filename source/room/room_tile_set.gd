class_name RoomTileSet
extends Resource

var total_count:int = 0
@export var list: Array[TileSetElement]:
	set(new_value):
		for i in range(new_value.size()):
			if new_value[i] is not TileSetElement:
				new_value[i] = TileSetElement.new()
		list = new_value

func init():
	total_count = 0
	for e in list:
		total_count += e.odds
	print_debug(str(total_count))
	return total_count != 0

func get_random_room_data(rng:RandomNumberGenerator) -> RoomTile:
	var i: int = rng.randi_range(0, total_count)
	var j: int = 0
	for r in list:
		if r.odds != 0:
			j += r.odds
			if i < j:
				return load(r.file).instantiate() as RoomTile
	return null
