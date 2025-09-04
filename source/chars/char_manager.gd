class_name CharManager
extends Node3D

static var main: CharManager = null
@export_file("*.tscn") var _prefab_file: String
@export_file("*.tres") var _stand_material_file: String
@export_file("*.tres") var _outline_material_file: String
@onready var _prefab: Resource = load(_prefab_file)
var _stand_material: ShaderMaterial

var _char_sets: Array[FileOddsList] = []
var chars: Array[Char] = []
var next_id:= 1

func _ready() -> void:
	main = self
	_stand_material = load(_stand_material_file) as ShaderMaterial
	_stand_material.set_shader_parameter("tex_albedo", null)
	_stand_material.set_shader_parameter("emmision", 0.0)

func clear() -> void:
	for chr in chars:
		chr.free()
	chars = []

func count() -> int:
	return chars.size()
	
func count_alive() -> int:
	var c := 0
	for chr in chars:
		if chr.is_alive():
			c += 1
	return c

func get_alive_list() -> Array[Char]:
	var list: Array[Char] = []
	for chr in chars:
		if chr.is_alive():
			list.append(chr)
	return list

func append_char_set(file: String) -> FileOddsList:
	var char_set : FileOddsList = load(file)
	char_set.id = _char_sets.size()
	_char_sets.append(char_set)
	return char_set

func get_char_set(id: int) -> FileOddsList:
	return _char_sets[id]

func new_char(from_set: int, pos: int, slot: RoomCharSlot) -> Char:
	var char_set := _char_sets[from_set]
	var data: CharData = load(char_set.file_at(pos))
	data.id = pos
	
	var chr: Char = _prefab.instantiate()
	chr.init(self, next_id, data, slot);
	chars.append(chr)
	next_id += 1
	Lobby.main.send_new_char(chr)
	return chr

func new_shadow_material() -> StandardMaterial3D:
	var mat: StandardMaterial3D = StandardMaterial3D.new()
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	return mat

func new_stand_material() -> ShaderMaterial:
	return _stand_material.duplicate()
