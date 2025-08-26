class_name RoomCharSlot
extends Selectable

@export var _size = 0.25
@export_file("*.png") var _material_file: String

var _mat: ShaderMaterial
var _char: Char = null

func _ready() -> void:
	var size = _size * 0.5
	scale = Vector3(size, size, size)
	var mesh: MeshInstance3D = find_child("mesh")
	var collider: StaticBody3D = find_child("collider")
	mesh.mesh = MeshGen.shared_plane()
	_mat = load(_material_file)
	mesh.material_override = _mat
	collider.collision_layer = Colliders.SLOT_MASK

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
		_update_selectable()

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

func _update_selectable() -> void:
	if _char:
		_mat.set_shader_parameter("outline_color", Colors.SLOT_FULL)
	elif _is_outlined:
		_mat.set_shader_parameter("outline_color", _current_outline)
	else:
		_mat.set_shader_parameter("outline_color", Colors.SLOT_EMPTY)
