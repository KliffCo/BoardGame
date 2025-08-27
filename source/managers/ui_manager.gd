class_name UIManager
extends Control

static var main: UIManager

func _ready() -> void:
	main = self
	get_tree().get_root().size_changed.connect(on_size_changed)
	on_size_changed()

func on_size_changed() -> void:
	PlayerManager.main.on_size_changed()
