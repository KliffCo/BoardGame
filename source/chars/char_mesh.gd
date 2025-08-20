class_name CharMesh
extends Node3D

var _shadow_mesh: MeshInstance3D
var _stand_mesh: MeshInstance3D
var _shadow_mat: StandardMaterial3D
var _stand_mat#: StandardMaterial3D

#var _char: Char:
	#get: return get_parent() as Char

func _ready() -> void:
	var _parent = get_parent_node_3d()
	_shadow_mesh = find_child("Shadow");
	_stand_mesh = find_child("Stand");
	_shadow_mesh.position = Vector3(0, MeshGen.SPACING*1, 0)
	#_stand_mat = MeshGen.new_material(_stand_mesh)
	#var a = load("res://shaders/char_material.tres")
	_stand_mat = load("res://shaders/char_material.tres")
	_shadow_mat = MeshGen.new_material(_shadow_mesh)
	#_stand_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
	_shadow_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	#_stand_mesh.rotate_x(_stand_mesh.rotation.x + deg_to_rad(-35))
	_stand_mesh.rotate_x(deg_to_rad(-35))

func set_stand_texture(tex: Texture2D):
	pass
	#_stand_mat.albedo_texture = tex

func set_shadow_texture(tex: Texture2D):
	_shadow_mat.albedo_texture = tex
