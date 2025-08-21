class_name CharMesh
extends Node3D

var _shadow_mesh: MeshInstance3D
var _shadow_mat: Material

var _stand_mesh: MeshInstance3D
var _stand1_mat: Material
var _stand2_mat: ShaderMaterial

#var _char: Char:
	#get: return get_parent() as Char

func _ready() -> void:
	var _parent = get_parent_node_3d()
	_shadow_mesh = find_child("Shadow");
	_stand_mesh = find_child("Stand");
	_shadow_mesh.position = Vector3(0, MeshGen.SPACING*1, 0)
	
	_stand1_mat = CharManager.main.new_base_material()
	_stand_mesh.material_override = _stand_mat1
	#_shadow_mat = CharManager.main.new_material()
	#_stand_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
	_shadow_mat = MeshGen.new_material(_shadow_mesh)
	_shadow_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	#_stand_mesh.rotate_x(_stand_mesh.rotation.x + deg_to_rad(-35))
	_stand_mesh.rotate_x(deg_to_rad(-35))

func set_stand_texture(tex: Texture2D):
	_stand_mat.set_shader_parameter("tex_albedo", tex)
	pass
	#_stand_mat.albedo_texture = tex

func set_shadow_texture(tex: Texture2D):
	_shadow_mat.albedo_texture = tex
	#_shadow_mat.albedo_texture = tex
