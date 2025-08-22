class_name MeshGen
extends Node

static var SPACING = 0.01

static var _shared_plane : ArrayMesh = null
static func shared_plane():
	if not _shared_plane:
		_shared_plane = plane()
	return _shared_plane

static func plane(offset:= Vector2(0.5, 0.5), rotate:= 1) -> ArrayMesh:
	rotate = clamp(rotate, 0, 2)
	
	var verticies: PackedVector3Array
	if rotate == 0:
		verticies = PackedVector3Array([
			Vector3(0, 0-offset.y, 1-offset.x),
			Vector3(0, 1-offset.y, 1-offset.x),
			Vector3(0, 1-offset.y, 0-offset.x),
			Vector3(0, 0-offset.y, 0-offset.x),
		])
	elif rotate == 1:
		verticies = PackedVector3Array([
			Vector3(0-offset.x, 0, 1-offset.y),
			Vector3(0-offset.x, 0, 0-offset.y),
			Vector3(1-offset.x, 0, 0-offset.y),
			Vector3(1-offset.x, 0, 1-offset.y),
		])
	else:
		verticies = PackedVector3Array([
			Vector3(0-offset.x, 0-offset.y, 0),
			Vector3(0-offset.x, 1-offset.y, 0),
			Vector3(1-offset.x, 1-offset.y, 0),
			Vector3(1-offset.x, 0-offset.y, 0),
		])
	
	var uvs:= PackedVector2Array([
		Vector2(0, 1),
		Vector2(0, 0),
		Vector2(1, 0),
		Vector2(1, 1)
	])
	
	var normals := PackedVector3Array([
		Vector3.ZERO,
		Vector3.ZERO,
		Vector3.ZERO,
		Vector3.ZERO,
	])
	for i in range(4):
		normals[i][rotate] = 1
	
	var indices := PackedInt32Array([
		0, 1, 2,
		0, 2, 3,
	])
	
	var array = []
	array.resize(Mesh.ARRAY_MAX)
	array[Mesh.ARRAY_VERTEX] = verticies
	array[Mesh.ARRAY_NORMAL] = normals
	array[Mesh.ARRAY_TEX_UV] = uvs
	array[Mesh.ARRAY_INDEX] = indices
	var mesh := ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, array)
	return mesh

static func new_material(mesh: MeshInstance3D = null) -> StandardMaterial3D:
	#var material: StandardMaterial3D = mesh.mesh.surface_get_material(0)
	#if material == null:
	Material
	var material: StandardMaterial3D = StandardMaterial3D.new()
	#material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	#material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
	#mesh.mesh.surface_set_material(0, material)
	if mesh:
		mesh.material_override = material
	return material
