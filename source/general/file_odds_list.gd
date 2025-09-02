@tool
class_name FileOddsList
extends Resource

@export var _list: Array[FileOdds]:
	set(new_value):
		for i in range(new_value.size()):
			if new_value[i] is not FileOdds:
				new_value[i] = FileOdds.new()
		_list = new_value

var id: int = 0
var _total_count: int = -1

func size() -> int:
	return _list.size()

func file_at(pos: int) -> String:
	return _list[pos].file

func _update_total() -> bool:
	_total_count = 0
	for e in _list:
		_total_count += e.odds
	return _total_count != 0

func get_random_id(rng:RandomNumberGenerator) -> int:
	if _total_count == -1:
		for e in _list:
			_total_count += e.odds
	var i: int = rng.randi_range(0, _total_count)
	var j: int = 0
	#for r in _list:
	for x in range(_list.size()):
		var r = _list[x]
		if r.odds != 0:
			j += r.odds
			if i < j:
				return x
	return _list.size()-1

func get_random(rng:RandomNumberGenerator) -> String:
	var x = get_random_id(rng)
	return _list[x].file
