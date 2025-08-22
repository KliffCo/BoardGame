class_name RoomCharSlot
extends Node3D

@export var _size = 0.25
@export_file("*.png") var _file

var _mat: StandardMaterial3D
var _color: Color = Color.WHITE
var _changing: bool = false
var _char: Char = null

func _ready() -> void:
	scale = Vector3(_size, _size, _size)
	var mesh: MeshInstance3D = find_child("mesh")
	var _texture : Texture2D = load(_file)
	mesh.mesh = MeshGen.shared_plane()
	_mat = MeshGen.new_material()
	_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	_mat.albedo_texture = _texture
	mesh.material_override = _mat
	#set_color(Color.RED)

var character: Char:
	get: return _char
	set(value):
		_char = value
		if value != null:
			set_color(Color.RED)

func set_color(color: Color, instant: bool = false):
	_color = color
	_changing = !instant
	if instant:
		_mat.albedo_color = color

func _process(delta: float) -> void:
	if not _changing:
		return
	if _mat.albedo_color != _color:
		_mat.albedo_color = _mat.albedo_color.lerp(_color, delta*3)
		var diff = _mat.albedo_color - _color
		if diff.r+diff.g+diff.b+diff.a < 0.05:
			_changing = false
