class_name TurnOrder
extends Control

static var main: TurnOrder = null
const NODE_PADDING := 5.0

enum Style { None, Player, Team, Char }

var tokens : Array[TurnToken] = []
var style := Style.None
var horizontal := true
var prefab : PlayerUI = null

func _ready() -> void:
	main = self
	prefab = get_child(0)
	remove_child(prefab)

func set_style(_style: Style):
	style = _style
	for c in get_children():
		remove_child(c)
	if style == Style.Player:
		var list = Lobby.main.players
		for p in list:
			add_player(p)

func add_player(p: Player) -> void:
	var token = prefab.duplicate() as PlayerUI
	add_child(token)
	token.set_owner(self)
	token.name = "player_"+str(p.id)
	token.set_player(p)
	sort_nodes(true)
	tokens.append(token)

func on_size_changed() -> void:
	sort_nodes(false)

func on_turn_changed() -> void:
	for t in tokens:
		t.on_turn_changed()

func sort_nodes(_animate: bool) -> void:
	if tokens.size() == 0:
		return
	var dir := Vector2(1.0, 0.0) if horizontal else Vector2(0.0, 1.0)
	var step : Vector2 = (tokens[0].get_rect().size + Vector2(NODE_PADDING, NODE_PADDING)) * dir
	var offset := Vector2(step.x * tokens.size() - NODE_PADDING, step.x * tokens.size() - NODE_PADDING) * Vector2(-0.5, -0.5) * dir
	
	for i in range(tokens.size()):
		var token: TurnToken = tokens[i]
		token.position = i*step+offset
