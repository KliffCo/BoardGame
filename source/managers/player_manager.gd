class_name PlayerManager
extends Control

static var main: PlayerManager = null
const NODE_PADDING := 5.0

var next_id:= 1
var list: Array[Player] = []
var _current: Player = null
var _me: Player = null

var horizontal:= true
var prefab: PlayerUI = null

var current: Player:
	get: return _current
	set(value):
		if _current:
			_current.node.set_active(false)
		_current = value
		if _current:
			_current.node.set_active(true)

func _ready() -> void:
	main = self
	prefab = get_child(0)
	remove_child(prefab)
	add_player()	# TODO temporary
	set_me(1)

func set_me(index: int) -> void:
	_me = null
	for p in list:
		if p.id == index:
			_me = p

func is_my_turn() -> bool:
	return _current == _me

func add_player() -> void:
	var p: Player = Player.new()
	p.id = next_id
	next_id += 1
	p.name = "Kliff"
	var a = load("res://images/players/player1.png")
	p.avatar = load("res://images/players/player1.png")
	
	p.node = prefab.duplicate() as PlayerUI
	add_child(p.node)
	p.node.set_owner(self)
	p.node.name = "player_"+str(p.id)
	p.node.set_player(p)
	list.append(p)
	sort_nodes(true)

func first_player() -> void:
	if list.size() == 0:
		return
	current = list[0]

func next_player() -> void:
	if list.size() == 0:
		return
	var index = list.find(current)
	current = list[(index+1)%list.size()]



func on_size_changed() -> void:
	sort_nodes(false)

func sort_nodes(animate: bool) -> void:
	if list.size() == 0:
		return
	var dir := Vector2(1.0, 0.0) if horizontal else Vector2(0.0, 1.0)
	var step := (list[0].node.get_rect().size + Vector2(NODE_PADDING, NODE_PADDING)) * dir
	var offset := Vector2(step.x * list.size() - NODE_PADDING, step.x * list.size() - NODE_PADDING) * Vector2(-0.5, -0.5) * dir
	
	for i in range(list.size()):
		var node: PlayerUI = list[i].node
		node.position = i*step+offset
