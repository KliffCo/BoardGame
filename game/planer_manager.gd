class_name PlayerManager
extends Node3D

static var main: PlayerManager = null

var list: Array[Player] = []

func _ready() -> void:
	main = self
	add_player()

func add_player():
	var p: Player = Player.new()
	p.id = 1
	p.name = "Kliff"
