class_name GameManager
extends Node3D

static var main: GameManager = null

func _ready() -> void:
	if main != null:
		return
	main = self
	DebugManager.main.on_ready()
