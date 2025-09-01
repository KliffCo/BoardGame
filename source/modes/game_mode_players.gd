class_name GameModePlayers
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

func start_game() -> void:
	TurnOrder.main.set_style(TurnOrder.Style.Player)
	current_player = Lobby.main.players[0]

func turn_finished() -> void:
	var list:= Lobby.main.players
	var index:= list.find(_current_player)
	current_player = list[(index+1)%list.size()]
