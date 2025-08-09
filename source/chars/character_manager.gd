class_name CharacterManager
extends Node3D

static var main: CharacterManager = null

#@export_file("*.tscn") var prefab: String
@onready var prefab: Resource = preload("res://chars/character.tscn")

func _ready() -> void:
	main = self
	new_char()

func new_char() -> Character:
	var chr: Character = prefab.instantiate()
	add_child(chr)
	return chr
