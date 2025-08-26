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

func set_is_outlined(value: bool):
	super.set_is_outlined(value)

func reset_color() -> void:
	set_is_outlined(false)
	set_outline_color(Colors.SLOT_EMPTY)

func _selectable_update() -> void:
	if _is_outlined || _is_color_changing:
		_mat.set_shader_parameter("animated", true)
		_mat.set_shader_parameter("outline_color", _current_outline)
		_mat.set_shader_parameter("emission", _current_outline.a*2.0 if _is_outlined else 0.0)
	else:
		_mat.set_shader_parameter("animated", false)
		_mat.set_shader_parameter("outline_color", Colors.SLOT_EMPTY)
		_mat.set_shader_parameter("emission", 0.0)
