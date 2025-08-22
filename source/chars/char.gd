class_name Char
extends Node3D

enum Action { Idle, Walk, Dodge, Hurt, Die, Dead, Attack, }

var data: CharData
var mesh: CharMesh
var anim: CharAnimator
var collider: PhysicsBody3D
var _slot: RoomCharSlot

var _is_selected: bool
var _is_selectable: bool
var _selectable_color: Color

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

var slot: RoomCharSlot:
	get:
		return _slot
	set(value):
		if _slot:
			_slot.character = null
		_slot = value
		if _slot:
			_slot.character = self

#func _process(delta: float) -> void:
	#anim.process(delta)

func set_selected(value: bool):
	_is_selected = value
	_update_outline()

func unset_selected():
	_is_selectable = false
	_update_outline()

func set_selectable(color):
	if _is_selectable == (color is Color):
		return
	_is_selectable = color is Color
	if _is_selectable:
		_selectable_color = color
	_update_outline()

func _update_outline():
	if _is_selected:
		mesh.set_outline(Colors.CHAR_SELECTED)
		return
	if _is_selectable:
		mesh.set_outline(_selectable_color)
		return
	mesh.unset_outline()
