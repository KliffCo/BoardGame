class_name CharMesh
extends Node3D

var _shadow_mesh: MeshInstance3D
var _stand_mesh: MeshInstance3D
var _shadow_mat: StandardMaterial3D
var _stand_mat: StandardMaterial3D

var _char: Char:
	get: return get_parent() as Char

func _ready() -> void:
	var _parent = get_parent_node_3d()
	_shadow_mesh = find_child("Shadow");
	_stand_mesh = find_child("Stand");
	_stand_mat = MeshGen.new_material(_stand_mesh)
	_shadow_mat = MeshGen.new_material(_shadow_mesh)
	#_stand_mesh.rotate_x(_stand_mesh.rotation.x + deg_to_rad(-35))
	_stand_mesh.rotate_x(deg_to_rad(-35))

func set_stand_texture(tex: Texture2D):
	_stand_mat.albedo_texture = tex

func set_shadow_texture(tex: Texture2D):
	_shadow_mat.albedo_texture = tex
