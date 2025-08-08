class_name Character
extends Node3D

@onready var mesh := CharMesh.new(self)
@onready var anim := CharAnimator.new(self)
var char: String
var act: Char.Action

func _ready() -> void:
	anim.load("goblin")
	#add_child(anim)
#	print_debug("A")
#	mesh.create(self)

func _process(delta: float) -> void:
	anim.process(delta)
	#pass
	##material.albedo_color = Color(0,0, rng.randf())
