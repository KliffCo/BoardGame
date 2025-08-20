class_name Nodes

static func _find_mesh(node: Node) -> MeshInstance3D:
	for child in node.get_children():
		if child is MeshInstance3D:
			return child
		var found = _find_mesh(child)
		if found:
			return found
	return null

static func _find_collider(node: Node) -> StaticBody3D:
	for child in node.get_children():
		if child is StaticBody3D:
			return child
		var found = _find_collider(child)
		if found:
			return found
	return null
