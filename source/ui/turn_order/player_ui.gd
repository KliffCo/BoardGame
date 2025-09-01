class_name PlayerUI
extends TurnToken

var player: Player = null
@onready var selected: Control = $selected

func _ready():
	for c in get_children():
		c.set_owner(self)

func set_player(value: Player) -> void:
	player = value
	if player:
		var label = find_child("name") as Label
		var image = find_child("image") as TextureRect
		label.text = player.name
		image.texture = player.avatar

func on_turn_changed() -> void:
	selected.visible = player.my_turn
