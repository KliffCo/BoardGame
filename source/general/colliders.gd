class_name Colliders

const CHAR_MASK = 2
const ROOM_MASK = 4
const SLOT_MASK = 8
const TEST_LAYER = 1<<19

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
	
	var query2 := PhysicsRayQueryParameters3D.create(origin, to, TEST_LAYER)
	query2.hit_from_inside = true
	var hits: Array = []
	for hit in list:
		var collider = hit.collider
		var original_layer = collider.collision_layer
		collider.collision_layer = TEST_LAYER
		var result = space_state.intersect_ray(query2)
		if result:
			var position: Vector3 = result.position
			hit["position"] = result.position
			hit["distance"] = origin.distance_to(position)
			hits.append(hit)
		collider.collision_layer = original_layer
	hits.sort_custom(func(a, b): return a["distance"] < b["distance"])
	return hits

static func get_ordered_ray_hits_in(space_state: PhysicsDirectSpaceState3D, origin: Vector3, dir: Vector3, length: float, list: Array[PhysicsBody3D]) -> Array:
	var to: Vector3 = origin + dir * length
	var query2 := PhysicsRayQueryParameters3D.create(origin, to, TEST_LAYER)
	query2.hit_from_inside = true
	var hits: Array = []
	for collider in list:
		var original_layer = collider.collision_layer
		collider.collision_layer = TEST_LAYER
		var hit = space_state.intersect_ray(query2)
		if hit:
			var position: Vector3 = hit.position
			hit["distance"] = origin.distance_to(position)
			hits.append(hit)
		collider.collision_layer = original_layer
	hits.sort_custom(func(a, b): return a["distance"] < b["distance"])
	return hits

static func get_ray_hit_in(space_state: PhysicsDirectSpaceState3D, origin: Vector3, dir: Vector3, length: float, list: Array[PhysicsBody3D]) -> Dictionary:
	var to: Vector3 = origin + dir * length
	var query2 := PhysicsRayQueryParameters3D.create(origin, to, TEST_LAYER)
	query2.hit_from_inside = true
	var original_layers: Array[int] = []
	for collider in list:
		original_layers.append(collider.collision_layer)
		collider.collision_layer = TEST_LAYER
	var hit = space_state.intersect_ray(query2)
	if hit:
		var position: Vector3 = hit.position
		hit["distance"] = origin.distance_to(position)
	for i in range(list.size()-1, -1, -1):
		list[i].collision_layer = original_layers[i]
	return hit
