@tool
class_name FileOddsList
extends Resource

@export var _list: Array[FileOdds]:
	set(new_value):
		for i in range(new_value.size()):
			if new_value[i] is not FileOdds:
				new_value[i] = FileOdds.new()
		_list = new_value

var _total_count:int = -1

func size():
	return _list.size()

func _update_total():
	_total_count = 0
	for e in _list:
		_total_count += e.odds
	return _total_count != 0

func get_random(rng:RandomNumberGenerator) -> String:
	if _total_count == -1:
		for e in _list:
			_total_count += e.odds
	var i: int = rng.randi_range(0, _total_count)
	var j: int = 0
	for r in _list:
		if r.odds != 0:
			j += r.odds
			if i < j:
				return r.file
	return ""
