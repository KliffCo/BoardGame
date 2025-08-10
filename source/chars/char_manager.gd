class_name CharManager
extends Node3D

static var main: CharManager = null

var chars: Array[Char] = []

func _ready() -> void:
	main = self

func clear():
	for char in chars:
		char.free()
	chars = []

func count() -> int:
	return chars.size()

func new_char(data: CharData, slot: RoomCharSlot) -> Char:
	var char: Char = Char.new(count(), data, slot)
	chars.append(char)
	add_child(char)
	return char
