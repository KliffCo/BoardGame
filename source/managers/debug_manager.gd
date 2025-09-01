class_name DebugManager
extends Node

static var main: DebugManager = null
enum State { None, Lobby, Bots, Load }
@export var state := State.None
@export_file("*.tres") var _game_mode: String
@export var bot_count := 0

func _ready() -> void:
	main = self

func on_ready() -> void:
	if state < State.Lobby:
		return
	LobbyControl.main.host()

func on_lobby_open() -> void:
	if state < State.Bots:
		return
	PlayerManager.main.add_human()
	for i in range(bot_count):
		PlayerManager.main.add_bot()
	PlayerManager.main.set_me(1)

	if state < State.Load or not _game_mode:
		return
	var game_mode := load(_game_mode) as GameMode
	game_mode.load_map()
