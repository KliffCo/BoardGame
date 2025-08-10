class_name Char
extends Node3D

enum Action { Idle, Walk, Dodge, Hurt, Die, Dead, Attack, }

static var _scale:= 0.5

var data: CharData
var mesh: CharMesh
var anim: CharAnimator
var _slot: RoomCharSlot

func _init(index: int, _data: CharData, slot: RoomCharSlot) -> void:
	data = _data
	name = "Char"+str(index)
	scale = Vector3(_scale, _scale, _scale)
	mesh = CharMesh.new(self)
	anim = CharAnimator.new(self)
	anim.load(data.sprites)
	set_slot(slot)
	position = _slot.global_position

func set_slot(slot: RoomCharSlot) -> void:
	if _slot:
		_slot.set_char(null)
	_slot = slot
	if _slot:
		_slot.set_char(self)

func _process(delta: float) -> void:
	anim.process(delta)
