class_name CharMesh
extends Resource

var char: Character
var _shadow_mesh: MeshInstance3D
var _stand_mesh: MeshInstance3D
var _shadow_mat: StandardMaterial3D
var _stand_mat: StandardMaterial3D

func _init(char: Node3D):
	self.char = char
	
	_shadow_mesh = MeshInstance3D.new()
	_shadow_mesh.name = "Shadow"
	char.add_child(_shadow_mesh)
	
	_stand_mesh = MeshInstance3D.new()
	_stand_mesh.name = "Stand"
	char.add_child(_stand_mesh)
	
	_shadow_mesh.mesh = MeshGen.plane(Vector2(0.5, 0.5), 1)
	_stand_mesh.mesh = MeshGen.plane(Vector2(0.5, 0), 2)
	
	_shadow_mat = _new_material(_shadow_mesh)
	_stand_mat = _new_material(_stand_mesh)

func _new_material(mesh: MeshInstance3D) -> StandardMaterial3D:
	var material: StandardMaterial3D = mesh.mesh.surface_get_material(0)
	if material == null:
		material = StandardMaterial3D.new()
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mesh.mesh.surface_set_material(0, material)
	return material

func set_stand_texture(tex: Texture2D):
	_stand_mat.albedo_texture = tex

func set_shadow_texture(tex: Texture2D):
	_shadow_mat.albedo_texture = tex
