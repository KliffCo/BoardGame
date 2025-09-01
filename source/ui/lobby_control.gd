class_name LobbyControl
extends Control

static var main: LobbyControl = null

func _ready() -> void:
	main = self
	visible = false

func host() -> void:
	pass
	DebugManager.main.on_lobby_open()
