class_name Colliders

const CHAR_MASK = 2
const ROOM_MASK = 4
const SLOT_MASK = 8

static func get_ordered_ray_hits(space_state: PhysicsDirectSpaceState3D, origin: Vector3, dir: Vector3, length: float, mask: int = 0xffffffff) -> Array:
	var to: Vector3 = origin + dir * length
	var query1: PhysicsShapeQueryParameters3D = PhysicsShapeQueryParameters3D.new()
	query1.shape = SeparationRayShape3D.new()
	query1.collision_mask = mask
	query1.shape.length = length
	query1.transform.origin = origin
	query1.transform = query1.transform.looking_at(to, Vector3.UP, true)
	var list = space_state.intersect_shape(query1)
	if list.size() == 0:
		return list
	
	var query2 := PhysicsRayQueryParameters3D.create(origin, to, 1 << 19)
	query2.hit_from_inside = true
	var hits: Array = []
	for hit in list:
		var collider = hit.collider
		var original_layer = collider.collision_layer
		collider.collision_layer = 1 << 19
		var result = space_state.intersect_ray(query2)
		if result:
			var hit_pos: Vector3 = result.position
			hit["hit_pos"] = result.position
			hit["distance"] = origin.distance_to(hit_pos)
			hits.append(hit)
		collider.collision_layer = original_layer
		
	hits.sort_custom(func(a, b): return a["distance"] < b["distance"])
	return hits
