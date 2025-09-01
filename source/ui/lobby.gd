class_name Lobby
extends Control

static var main: Lobby = null
var connected := false
var is_host := false
var next_id:= 1
var players: Array[Player] = []
var me: Player = null

func _ready() -> void:
	main = self
	visible = false

func close() -> void:
	connected = false
	is_host = false
	me = null
	players.clear()
	next_id = 1

func host() -> void:
	connected = true
	is_host = true
	DebugManager.main.on_lobby_open()

func join() -> void:
	connected = true
	is_host = false

func find_player(index: int) -> Player:
	for p in players:
		if p.id == index:
			return p
	return null

func set_me(index: int) -> void:
	me = find_player(index)

#func is_my_turn() -> bool:
	#return me.my_turn

func add_human() -> void:
	var p:= HumanPlayer.new()
	init_player(p)

func add_bot() -> void:
	var p:= GameMode.main.new_bot()
	init_player(p)

func init_player(p: Player) -> void:
	p.id = next_id
	next_id += 1
	p.name = "Kliff"
	p.avatar = load("res://images/players/player1.png")
	players.append(p)
