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

#func reset_color() -> void:
	#set_stroke(false, Color.TRANSPARENT)

func _selectable_update() -> void:
	var fill := _current_fill.a > 0.01
	var stroke := _is_stroked || _is_color_changing
	
	_mat.set_shader_parameter("noise", stroke)
	_mat.set_shader_parameter("fill", fill)
	if fill:
		_mat.set_shader_parameter("fill_color", _current_fill)
	_mat.set_shader_parameter("emission", _current_fill.a*3.0)
	if stroke:
		_mat.set_shader_parameter("speed", 0.35)
		_mat.set_shader_parameter("stroke_color", _current_stroke)
	else:
		_mat.set_shader_parameter("speed", 0.0)
		_mat.set_shader_parameter("stroke_color", Colors.SLOT_EMPTY)
