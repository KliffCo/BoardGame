class_name UIManager
extends CanvasLayer

static var main: UIManager = null

func _ready() -> void:
	main = self
	get_tree().get_root().size_changed.connect(on_size_changed)
	on_size_changed()

func on_size_changed() -> void:
	TurnOrder.main.on_size_changed()
