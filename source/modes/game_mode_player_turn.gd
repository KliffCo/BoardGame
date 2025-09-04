class_name GameModePlayerTurn
extends GameMode

var _current_player: Player = null

var current_player: Player:
	get: return _current_player
	set(value):
		if _current_player:
			_current_player.my_turn = false
			_current_player.turn_finished()
		_current_player = value
		if _current_player:
			_current_player.my_turn = true
			turn_started()
			_current_player.turn_started()
		TurnOrder.main.on_turn_changed()

func level_loaded() -> void:
	if Lobby.main.is_host:
		Lobby.main.send_start_level()
		Lobby.main.send_set_turn(Lobby.main.players[0].id)

func on_start_level() -> void:
	TurnOrder.main.set_style(TurnOrder.Style.Player)

func turn_finished() -> void:
	var list:= Lobby.main.players
	var index:= list.find(_current_player)
	var player:= Lobby.main.players[(index+1)%list.size()]
	Lobby.main.send_set_turn(player.id)

func on_set_turn(id: int) -> void:
	var player:= Lobby.main.find_player(id)
	current_player = player
