class_name CharManager
extends Node3D

static var main: CharManager = null
@export_file("*.tscn") var _prefab_file: String
@export_file("*.tres") var _material_file: String
@onready var _prefab: Resource = load(_prefab_file)
@onready var _material: Resource = load(_material_file)

var chars: Array[Char] = []

func _ready() -> void:
	main = self

func clear():
	for chr in chars:
		chr.free()
	chars = []

func count() -> int:
	return chars.size()

func new_char(data: CharData, slot: RoomCharSlot) -> Char:
	var chr: Char = _prefab.instantiate()
	chr.init(self, count(), data, slot);
	chars.append(chr)
	return chr

func new_material() -> ShaderMaterial:
	return _material.duplicate()
