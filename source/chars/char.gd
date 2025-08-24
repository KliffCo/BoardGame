class_name Char
extends Selectable

enum Action { Idle, Walk, Dodge, Hurt, Die, Dead, Attack, }

const WALK_SPEED = 1.0

var data: CharData
var mesh: CharMesh
var anim: CharAnimator
var collider: PhysicsBody3D
var _slot: RoomCharSlot

var health: int = 1
#var team: int
#var items: []

var _is_selected := false
var _is_walking := false
var _walk_index = 0
var _walk_points: Array[Vector3]
var _walk_callback: Callable = Null.CALLABLE

func init(parent: Node3D, index: int, _data: CharData, _slot: RoomCharSlot) -> void:
	self.data = _data
	self.slot = _slot
	name = "char_"+str(index)
	mesh = find_child("mesh")
	anim = find_child("anim")
	init_collider()
	
	parent.add_child(self)
	position = _slot.global_position
	#scale = Vector3(_scale, _scale, _scale)
	anim.load(data.sprites)
	health = data.health

func init_collider() -> void:
	collider = StaticBody3D.new()
	collider.name = "collider"
	collider.collision_layer = Colliders.CHAR_MASK
	var shape := CollisionShape3D.new()
	shape.name = "cylinder"
	var cylinder = CylinderShape3D.new()
	cylinder.height = data.col_height
	cylinder.radius = data.col_radius
	shape.shape = cylinder
	collider.add_child(shape)
	add_child(collider)
	var angle = deg_to_rad(mesh._angle)
	collider.rotation = Vector3(angle, 0, 0)
	collider.position = Vector3(0, data.col_height * 0.5 * cos(angle), data.col_height * 0.5 * sin(angle))

var is_alive: bool:
	get: return health > 0

var room : Room:
	get: return _slot.room

var slot: RoomCharSlot:
	get:
		return _slot
	set(value):
		if _slot:
			_slot.character = null
		_slot = value
		if _slot:
			_slot.character = self

func _selectable_update() -> void:
	mesh.set_outline(_current_color, _current_color.a * 0.5)
	if not _is_color_changing:
		if not _is_selectable:
			mesh.unset_outline()

func get_selectables() -> Array[ActionSelectable]:
	var list: Array[ActionSelectable] = []
	for action in data.actions:
		var more = action.get_selectables(self)
		list.append_array(more)
	return list

func invoke_action(action, selectable) -> void:
	action.invoke(self, selectable)

func walk_to(points: Array[Vector3], callback: Callable) -> void:
	_walk_callback.call()
	_walk_callback = callback
	_walk_points = points
	_walk_index = 0
	_is_walking = _walk_points.size() > 0
	if _is_walking:
		anim.set_action(Action.Walk)
	else:
		anim.set_action(Action.Idle)
		_walk_callback.call()

func try_damage(damage: int, attacker: Char, callback: Callable) -> void:
	damage(damage, attacker, callback)

func damage(damage: int, _attacker: Char, callback: Callable) -> void:
	anim.play_once(Char.Action.Hurt, func():
		health -= damage
		if is_alive:
			anim.set_action(Char.Action.Idle);
			callback.call(true)
		else:
			anim.play_once(Char.Action.Die, func():
				anim.play_once(Char.Action.Dead, func():
					callback.call(true)
				)
			)
	)

func _process(delta: float) -> void:
	_process_color(delta)
	if _is_walking:
		position = position.move_toward(_walk_points[_walk_index], delta * WALK_SPEED)
		if position == _walk_points[_walk_index]:
			anim.set_action(Action.Idle)
			_walk_callback.call()
			_walk_callback = Null.CALLABLE
			_is_walking = false
