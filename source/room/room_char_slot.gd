class_name RoomCharSlot
extends Selectable

@export var _size = 0.25
@export_file("*.tres") var _material_file: String

var _mat: ShaderMaterial = null
var _char: Char = null

func _ready() -> void:
	var size = _size * 0.5
	scale = Vector3(size, size, size)
	var mesh: MeshInstance3D = find_child("mesh")
	var collider: StaticBody3D = find_child("collider")
	mesh.mesh = MeshGen.shared_plane()
	_mat = load(_material_file).duplicate()
	mesh.material_override = _mat
	_selectable_update()

var room: Room:
	get:
		var node = get_parent_node_3d()
		while node:
			if node is Room:
				return node
			node = node.get_parent_node_3d()
		return null

var is_empty: bool:
	get: return character == null

var character: Char:
	get: return _char
	set(value):
		_char = value
		#_update_selectable()

#func set_color(color: Color, instant: bool = false):
	#_color = color
	#_changing = !instant
	#if instant:
		#_mat.albedo_color = color

#func _process(delta: float) -> void:
	#if not _changing:
		#return
	#if _mat.albedo_color != _color:
		#_mat.albedo_color = _mat.albedo_color.lerp(_color, delta*3)
		#var diff = _mat.albedo_color - _color
		#if diff.r+diff.g+diff.b+diff.a < 0.05:
			#_changing = false

func reset_color() -> void:
	_mat.set_shader_parameter("animated", false)
	_mat.set_shader_parameter("outline_color", Colors.SLOT_EMPTY)
	_mat.set_shader_parameter("emission", 0)

func _selectable_update() -> void:
	if _is_outlined || _is_color_changing:
		_mat.set_shader_parameter("animated", true)
		_mat.set_shader_parameter("outline_color", _current_outline)
		_mat.set_shader_parameter("emission", outline_color.a*2.0)
	else:
		reset_color()
