class_name Char
extends Node3D

enum Action { Idle, Walk, Dodge, Hurt, Die, Dead, Attack, }

static var _scale:= 0.5

var data: CharData
var mesh: CharMesh
var anim: CharAnimator

func _init(char: String) -> void:
	scale = Vector3(_scale, _scale, _scale)
	mesh = CharMesh.new(self)
	anim = CharAnimator.new(self)
	
	anim.load("goblin")

#func _ready() -> void:

func _process(delta: float) -> void:
	anim.process(delta)
