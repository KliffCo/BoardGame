class_name PlayerManager
extends Control

static var main: PlayerManager = null
const NODE_PADDING := 5.0

var current: Player = null

var list: Array[Player] = []

var horizontal := true
var prefab : PlayerUI = null

func _ready() -> void:
	main = self
	prefab = get_child(0)
	remove_child(prefab)
	add_player()	# TODO temporary
	add_player()	# TODO temporary

func add_player() -> void:
	var p: Player = Player.new()
	p.id = 1
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
	var size := list[0].node.get_rect().size
	var step := Vector2(size.x + NODE_PADDING, size.y + NODE_PADDING) * dir
	var total_size := Vector2(step.x * list.size() - NODE_PADDING, step.x * list.size() - NODE_PADDING) * dir
	var offset = Vector2(-total_size.x*0.5, -total_size.y*0.5) * dir
	
	for i in range(list.size()):
		var node: PlayerUI = list[i].node
		node.position = i*step+offset
