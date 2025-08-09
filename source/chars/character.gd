class_name Character
extends Node3D

@onready var mesh := CharMesh.new(self)
@onready var anim := CharAnimator.new(self)

func _ready() -> void:
	anim.load("goblin")

func _process(delta: float) -> void:
	anim.process(delta)
