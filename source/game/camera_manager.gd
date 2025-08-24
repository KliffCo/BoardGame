class_name CameraManager
extends Camera3D

static var main: CameraManager

var _actual_pan: Vector3
var _desired_pan: Vector3
var _actual_zoom: float = 0.5
var _desired_zoom: float = 0.5
var _zoom_offset: Vector3

@export var min_zoom_offset: Vector3 = Vector3(0, 3, 1)
@export var max_zoom_offset: Vector3 = Vector3(0, 1, 1)
@export_range(-180, 180) var min_zoom_angle: float = -70
@export_range(-180, 180) var max_zoom_angle: float = -30

func get_actual_pan() -> Vector3:
	return _actual_pan

func get_desired_pan() -> Vector3:
	return _desired_pan

func get_actual_zoom() -> float:
	return _actual_zoom

func get_desired_zoom() -> float:
	return _desired_zoom
	
func _ready() -> void:
	main = self
	_zoom_offset = min_zoom_offset.lerp(max_zoom_offset, _actual_zoom)
	position = _actual_pan + _zoom_offset
	rotation_degrees = Vector3(lerp(min_zoom_angle, max_zoom_angle, _actual_zoom), 0, 0)

func set_actual_zoom(zoom: float):
	_actual_zoom = clamp(zoom, 0, 1)
	_desired_zoom = _actual_zoom
	_zoom_offset = min_zoom_offset.lerp(max_zoom_offset, _actual_zoom)

func set_desired_zoom(zoom: float):
	_desired_zoom = clamp(zoom, 0, 1)

func set_actual_pan(pan: Vector3):
	if pan.y < 0:
		return
	pan.y = 0
	_actual_pan = pan
	_desired_pan = pan

func set_desired_pan(pan: Vector3):
	if pan.y < 0:
		return
	pan.y = 0
	_desired_pan = pan

func _process(_delta: float) -> void:
	if _actual_zoom != _desired_zoom:
		_actual_zoom = lerp(_actual_zoom, _desired_zoom, 0.2)
		if abs(_actual_zoom-_desired_zoom) < 0.001:
			_actual_zoom = _desired_zoom
		_zoom_offset = min_zoom_offset.lerp(max_zoom_offset, _actual_zoom)
	if _actual_pan != _desired_pan:
		_actual_pan = _actual_pan.lerp(_desired_pan, 0.25)
		if (_actual_pan - _desired_pan).length_squared() < 0.001:
			_actual_pan = _desired_pan
	#_actual_pan = _actual_pan.clamp(RoomManager.main.min_range, RoomManager.main.max_range)
	var distance = (_actual_pan-RoomManager.main.mid_pos).length()
	if distance > RoomManager.main.radius + 1:
		_actual_pan = RoomManager.main.mid_pos + (_actual_pan - RoomManager.main.mid_pos).normalized() * (RoomManager.main.radius + 1)
	position = _actual_pan + _zoom_offset
	rotation_degrees = Vector3(lerp(min_zoom_angle, max_zoom_angle, ease(_actual_zoom, 2)), 0, 0)

func screen_to_world_pos(screen_pos: Vector2):
	var direction = project_ray_normal(screen_pos)
	if direction.y > -0.01:
		return false
	var origin = position # project_ray_origin(screen_pos)
	var ray_length = abs(origin.y/direction.y)
	var end = origin + direction * ray_length
	return end

func world_to_screen_pos(world_pos: Vector3) -> Vector2:
	return unproject_position(world_pos)

func colliders_at_screen_pos(screen_pos: Vector2, mask: int = 0xffffffff) -> Array:
	var direction = project_ray_normal(screen_pos)
	var list = Colliders.get_ordered_ray_hits(get_world_3d().direct_space_state, position, direction, 10, mask)
	return list

func colliders_at_screen_pos_in(screen_pos: Vector2, from_list: Array[PhysicsBody3D]) -> Array:
	var direction = project_ray_normal(screen_pos)
	var list = Colliders.get_ordered_ray_hits_in(get_world_3d().direct_space_state, position, direction, 10, from_list)
	return list

func collider_at_screen_pos_in(screen_pos: Vector2, from_list: Array[PhysicsBody3D]) -> Dictionary:
	var direction = project_ray_normal(screen_pos)
	return Colliders.get_ray_hit_in(get_world_3d().direct_space_state, position, direction, 10, from_list)
