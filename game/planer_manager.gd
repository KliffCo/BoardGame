class_name PlayerManager
extends Node3D

static var main: PlayerManager = null
var current: Player = null

var list: Array[Player] = []

func _ready() -> void:
	main = self
	add_player()

func add_player():
	var p: Player = Player.new()
	p.id = 1
	p.name = "Kliff"

func first_player():
	if list.size() == 0:
		return
	current = list[0]

func next_player():
	if list.size() == 0:
		return
	var index = list.find(current)
	current = list[(index+1)%list.size()]
