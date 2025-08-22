class_name Char
extends Selectable

enum Action { Idle, Walk, Dodge, Hurt, Die, Dead, Attack, }

var data: CharData
var mesh: CharMesh
var anim: CharAnimator
var collider: PhysicsBody3D
var _slot: RoomCharSlot

func init(parent: Node3D, index: int, __data: CharData, __slot: RoomCharSlot) -> void:
	self.data = __data
	self.slot = __slot
	name = "Char"+str(index)
	mesh = find_child("mesh")
	anim = find_child("anim")
	collider = find_child("collider")
	collider.collision_mask = Colliders.CHAR_MASK
	
	parent.add_child(self)
	position = _slot.global_position
	#scale = Vector3(_scale, _scale, _scale)
	anim.load(data.sprites)

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

func _update_selectable() -> void:
	if _is_selected:
		mesh.set_outline(Colors.CHAR_SELECTED)
		return
	if _is_selectable:
		mesh.set_outline(_selectable_color)
		return
	mesh.unset_outline()

#func _process(delta: float) -> void:
	#anim.process(delta)

#func unset_selected() -> void:
	#_is_selectable = false
	#_update_outline()

func get_selectables() -> Array[ActionSelectable]:
	var list := [ActionSelectable]
	for action in data.actions:
		var more = action.get_selectables(self)
		list.append_array(more)
	return list
