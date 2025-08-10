class_name CharMesh
extends Resource

var _char: Char
var _shadow_mesh: MeshInstance3D
var _stand_mesh: MeshInstance3D
var _shadow_mat: StandardMaterial3D
var _stand_mat: StandardMaterial3D

func _init(chr: Node3D):
	_char = chr
	
	_shadow_mesh = MeshInstance3D.new()
	_shadow_mesh.name = "Shadow"
	_char.add_child(_shadow_mesh)
	
	_stand_mesh = MeshInstance3D.new()
	_stand_mesh.name = "Stand"
	_char.add_child(_stand_mesh)
	
	_stand_mesh.mesh = MeshGen.plane(Vector2(0.5, 0), 2)
	_stand_mesh.rotate_x(deg_to_rad(-35))
	_stand_mat = MeshGen.new_material(_stand_mesh)

	_shadow_mesh.mesh = MeshGen.plane(Vector2(0.5, 0.5), 1)
	_shadow_mesh.position = Vector3(0, 0.01, 0)
	_shadow_mat = MeshGen.new_material(_shadow_mesh)

func set_stand_texture(tex: Texture2D):
	_stand_mat.albedo_texture = tex

func set_shadow_texture(tex: Texture2D):
	_shadow_mat.albedo_texture = tex
