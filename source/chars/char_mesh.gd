class_name CharMesh
extends Node3D

static var _stand_plane: ArrayMesh = null
var _shadow_mesh: MeshInstance3D
var _shadow_mat: Material
var _stand_mesh: MeshInstance3D
var _stand_mat: StandardMaterial3D
var _outline_mesh: MeshInstance3D
var _outline_mat: ShaderMaterial

#var _char: Char:
	#get: return get_parent() as Char

func _ready() -> void:
	var _parent = get_parent_node_3d()
	
	scale = Vector3(0.5, 0.5, 0.5)
	_shadow_mesh = find_child("shadow");
	_stand_mesh = find_child("stand");
	_outline_mesh = find_child("outline");
	if not _stand_plane:
		#_stand_plane = MeshGen.plane(Vector2(0.5, 1.0))
		_stand_plane = MeshGen.plane(Vector2(0.5, 0.0), 2)
	
	_shadow_mesh.position = Vector3(0, MeshGen.SPACING*1, 0)
	_shadow_mesh.mesh = MeshGen.shared_plane();
	_shadow_mat = CharManager.main.new_shadow_material()
	_shadow_mesh.material_override = _shadow_mat
	
	_stand_mesh.rotate_x(deg_to_rad(-35))
	_stand_mesh.mesh = _stand_plane;
	_stand_mat = CharManager.main.new_stand_material()
	_stand_mesh.material_override = _stand_mat
	
	_outline_mesh.visible = false
	_outline_mesh.mesh = _stand_plane;
	_outline_mat = CharManager.main.new_outline_material()
	_outline_mesh.material_override = _outline_mat


func set_stand_texture(tex: Texture2D):
	_stand_mat.albedo_texture = tex
	_outline_mat.set_shader_parameter("tex_albedo", tex)

func set_shadow_texture(tex: Texture2D):
	_shadow_mat.albedo_texture = tex

func set_outline(color: Color):
	_outline_mesh.visible = true
	#_outline_mat.set_shader_parameter("outline_size", 3.0)
	_outline_mat.set_shader_parameter("outline_color", color)
	
func unset_outline():
	_outline_mesh.visible = false
	#_stand_mat.set_shader_parameter("outline_size", 0.0)
	
