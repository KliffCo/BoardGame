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
var selected: Char = null

func _ready() -> void:
	main = self
	_stand_material = load(_stand_material_file) as ShaderMaterial
	_stand_material.set_shader_parameter("tex_albedo", null)
	_stand_material.set_shader_parameter("emmision", 0.0)
	_outline_material = load(_outline_material_file) as ShaderMaterial
	_outline_material.set_shader_parameter("tex_albedo", null)
	_outline_material.set_shader_parameter("outline_size", 3.0)

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

func new_shadow_material() -> StandardMaterial3D:
	var mat: StandardMaterial3D = StandardMaterial3D.new()
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	return mat

func new_stand_material() -> ShaderMaterial:
	#var mat: StandardMaterial3D = StandardMaterial3D.new()
	#mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
	#return mat
	return _stand_material.duplicate()

func new_outline_material() -> ShaderMaterial:
	return _outline_material.duplicate()

func select(chr: Char):
	if selected:
		selected.set_selected(false)
	selected = chr
	if selected:
		selected.set_selected(true)
