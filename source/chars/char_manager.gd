class_name CharManager
extends Node3D

static var main: CharManager = null
@export_file("*.tscn") var _prefab_file: String
@export_file("*.tres") var _stand_material_file: String
@export_file("*.tres") var _outline_material_file: String
@onready var _prefab: Resource = load(_prefab_file)
var _stand_material: ShaderMaterial
var _outline_material: ShaderMaterial

var chars: Array[Char] = []

func _ready() -> void:
	main = self
	_stand_material = load(_stand_material_file) as ShaderMaterial
	_stand_material.set_shader_parameter("tex_albedo", null)
	_stand_material.set_shader_parameter("emmision", 0.0)
	_outline_material = load(_outline_material_file) as ShaderMaterial
	_outline_material.set_shader_parameter("tex_albedo", null)

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

func new_char(data: CharData, slot: RoomCharSlot) -> Char:
	var chr: Char = _prefab.instantiate()
	chr.init(self, count(), data, slot);
	chars.append(chr)
	return chr

func new_shadow_material() -> StandardMaterial3D:
	var mat: StandardMaterial3D = StandardMaterial3D.new()
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	return mat

func new_stand_material() -> ShaderMaterial:
	return _stand_material.duplicate()

func new_outline_material() -> ShaderMaterial:
	return _outline_material.duplicate()

#func try_select(chr: Char) -> bool:
	#if GameMode.main.can_select_char(chr):
		#select(chr)
		#return true
	#return false
