class_name Char
extends Selectable

enum Action { Idle, Walk, Dodge, Hurt, Die, Dead, Attack, }

const WALK_SPEED = 1.0
static var NULL_CALLABLE := func(): pass

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
var _walk_callback: Callable = NULL_CALLABLE

func init(parent: Node3D, index: int, __data: CharData, __slot: RoomCharSlot) -> void:
	self.data = __data
	self.slot = __slot
	name = "char_"+str(index)
	mesh = find_child("mesh")
	anim = find_child("anim")
	collider = find_child("collider")
	collider.collision_mask = Colliders.CHAR_MASK
	
	parent.add_child(self)
	position = _slot.global_position
	#scale = Vector3(_scale, _scale, _scale)
	anim.load(data.sprites)
	health = data.health

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
	if _is_color_changing:
		mesh.set_outline(_current_color, _current_color.a * 0.5)
	else:
		if not _is_selectable:
			mesh.unset_outline()

func get_selectables() -> Array[ActionSelectable]:
	var list: Array[ActionSelectable] = []
	for action in data.actions:
		var more = action.get_selectables(self)
		list.append_array(more)
	return list

func try_damage(damage: int, _attacker: Char) -> bool:
	health -= damage
	return true

func invoke_action(action, selectable) -> void:
	action.invoke(self, selectable)

func walk_to(points: Array[Vector3], callback: Callable):
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

func _process(delta: float) -> void:
	_process_color(delta)
	if _is_walking:
		position = position.move_toward(_walk_points[_walk_index], delta * WALK_SPEED)
		if position == _walk_points[_walk_index]:
			anim.set_action(Action.Idle)
			_walk_callback.call()
			_walk_callback = NULL_CALLABLE
			_is_walking = false
