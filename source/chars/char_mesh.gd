class_name CharMesh
extends Node3D

static var _stand_plane: Mesh = null
var _holder: Node3D
var _shadow_mesh: MeshInstance3D
var _shadow_mat: Material
var _stand_mesh: MeshInstance3D
var _stand_mat: ShaderMaterial
var _outline_mesh: MeshInstance3D
var _outline_mat: ShaderMaterial

var _angle : float = -30
var _size := Vector2(0.5, 0.5)
var _pivot := Vector2(0.0, -1.0)

#var _char: Char:
	#get: return get_parent() as Char

#func _process(delta: float) -> void:
	#translate_stand()

func _ready() -> void:
	var _parent = get_parent_node_3d()
	
	_holder = find_child("holder");
	_shadow_mesh = find_child("shadow");
	_stand_mesh = find_child("stand");
	_outline_mesh = find_child("outline");
	if not _stand_plane:
		_stand_plane = MeshGen.shared_plane()
	
	_shadow_mesh.position = Vector3(0, MeshGen.SPACING*1, 0)
	_shadow_mesh.scale = Vector3(0.25, 0.25, 0.25)
	_shadow_mesh.mesh = MeshGen.shared_plane();
	_shadow_mat = CharManager.main.new_shadow_material()
	_shadow_mesh.material_override = _shadow_mat
	
	_stand_mesh.mesh = _stand_plane;
	_stand_mat = CharManager.main.new_stand_material()
	_stand_mesh.material_override = _stand_mat
	
	_outline_mesh.visible = false
	_outline_mesh.mesh = _stand_plane;
	_outline_mat = CharManager.main.new_outline_material()
	_outline_mesh.material_override = _outline_mat
	
	translate_stand()
	unset_outline()
	
func translate_stand() -> void:
	var size := _size * 0.5
	var y := _pivot.y * size.y
	var angle_rag := deg_to_rad(90+_angle)
	_holder.position = Vector3(-_pivot.x * size.x, -y * sin(angle_rag), y * cos(angle_rag))
	_holder.rotation = Vector3(deg_to_rad(90+_angle), 0.0, 0.0)
	_holder.scale = Vector3(size.x, 1.0, size.y)

func set_stand_texture(tex: Texture2D):
	_stand_mat.set_shader_parameter("tex_albedo", tex)
	_outline_mat.set_shader_parameter("tex_albedo", tex)

func set_shadow_texture(tex: Texture2D):
	_shadow_mat.albedo_texture = tex

func set_outline(color: Color, glow: float):
	_outline_mesh.visible = true
	_stand_mat.set_shader_parameter("emission", glow)
	_outline_mat.set_shader_parameter("outline_color", color)

func unset_outline():
	_outline_mesh.visible = false
	_stand_mat.set_shader_parameter("emission", 0.0)
