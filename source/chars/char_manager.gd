class_name CharManager
extends Node3D

static var main: CharManager = null
@export_file("*.tscn") var _prefab_file: String
@onready var _prefab: Resource = load(_prefab_file)

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
	var char: Char = _prefab.instantiate()
	char.init(self, count(), data, slot);
	chars.append(char)
	return char
