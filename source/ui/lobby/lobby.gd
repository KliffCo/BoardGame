class_name Lobby
extends Control

static var main: Lobby = null
var server : Server = null
var client : Client = null
var connected := false
var is_host := false
var players : Array[Player] = []
var me: HumanPlayer = null

func _ready() -> void:
	main = self
	visible = false

func _process(delta: float) -> void:
	if server:
		server.process()
	if client:
		client.process()

func close() -> void:
	connected = false
	is_host = false
	me = null
	players.clear()
	server = null

func host() -> void:
	connected = true
	is_host = true
	server = Server.new()
	client = Client.new("127.0.0.1", Server.PORT)
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

func is_my_turn() -> bool:
	return me and me.my_turn

func add_human() -> HumanPlayer:
	var id = new_player_id()
	if id == 0:
		return null
	var p:= HumanPlayer.new()
	init_player(p, id)
	return p

func add_bot() -> BotPlayer:
	var id = new_player_id()
	if id == 0:
		return null
	var p:= GameMode.main.new_bot()
	init_player(p, id)
	return p

func new_player_id() -> int:
	for id in range(1, 32):
		if not find_player(id):
			return id
	return 0

func add_player(id: int) -> Player:
	var p := find_player(id)
	if p:
		return p
	p = Player.new()
	init_player(p, id)
	return p

func init_player(p: Player, id: int) -> void:
	p.id = id
	p.name = "Kliff"
	p.avatar = load("res://images/players/player1.png")
	players.append(p)

func load_game_mode(file: String) -> void:
	var game_mode := load(file) as GameMode
	game_mode.init()

func send_new_char(chr: Char) -> void:
	for p in players:
		if p is HumanPlayer:
			p.send_new_char(chr)

func send_my_chars() -> void:
	for p in players:
		p.send_my_chars()

func send_start_level() -> void:
	for p in players:
		p.send_start_level()

func send_set_turn(id: int) -> void:
	for p in players:
		if p is HumanPlayer:
			p.send_set_turn(id)
