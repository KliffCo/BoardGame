class_name Char
extends Node3D

enum Action { Idle, Walk, Dodge, Hurt, Die, Dead, Attack, }

static var _scale:= 0.5

@export var Abc: int = 1
var data: CharData
var mesh: CharMesh
var anim: CharAnimator
var _slot: RoomCharSlot

func init(parent: Node3D, index: int, __data: CharData, __slot: RoomCharSlot) -> void:
	self.data = __data
	self.slot = __slot
	name = "Char"+str(index)
	mesh = find_child("mesh")
	anim = find_child("anim")

	parent.add_child(self)
	position = _slot.global_position
	scale = Vector3(_scale, _scale, _scale)
	anim.load(data.sprites)

var slot: RoomCharSlot:
	get:
		return _slot
	set(value):
		if _slot:
			_slot.char = null
		_slot = value
		if _slot:
			_slot.char = self

func _process(delta: float) -> void:
	anim.process(delta)
