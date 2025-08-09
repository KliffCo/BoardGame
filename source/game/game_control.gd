class_name GameControl
extends Node3D

static var main: Game

func _ready() -> void:
	main = self
	_init_map()
	
func _init_map():
	for child in get_parent().get_children():
		if child is MapGenerator:
			return
	
