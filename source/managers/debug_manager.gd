class_name DebugManager
extends Node

static var main: DebugManager = null
enum State { None, Lobby, Load, Bots, Start }
@export var state := State.None
@export_file("*.tres") var _game_mode: String
@export var bot_count := 0

func _ready() -> void:
	main = self

func on_ready() -> void:
	if state < State.Lobby:
		return
	Lobby.main.host()

func on_lobby_open() -> void:
	if state < State.Load:
		return

func on_connected() -> void:
	if state < State.Load or not _game_mode:
		return
	var game_mode := load(_game_mode) as GameMode
	Lobby.main.send_game_mode(game_mode.name.hash())

func on_game_mode() -> void:
	if state < State.Bots or not _game_mode:
		return
	for i in range(bot_count):
		Lobby.main.add_bot()
	if state < State.Start or not _game_mode:
		return
	GameMode.main.start_game()
