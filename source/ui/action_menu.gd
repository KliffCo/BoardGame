class_name ActionMenu
extends Control

static var main : ActionMenu
var container: VBoxContainer
var prefab: ActionMenuCell = null
var _list: Array[ActionSelectable] = []

func _ready() -> void:
	main = self
	container = find_child("container")
	prefab = container.get_child(0)
	close()

func _unhandled_input(e: InputEvent) -> void:
	if not visible:
		return
	var viewport = get_viewport()
	if e is InputEventMouseButton && e.pressed:
		close()
	viewport.set_input_as_handled()

func open(pos: Vector2, chr: Char, list: Array[ActionSelectable]) -> void:
	close()
	_list = list
	for act in _list:
		var cell = prefab.duplicate() as ActionMenuCell
		container.add_child(cell)
		cell.set_owner(self)
		cell.setup(chr, act)
	visible = true
	var view_size := get_viewport().get_visible_rect().size
	var cell_size:= prefab.get_rect().size
	size = Vector2(cell_size.x, cell_size.y * _list.size())
	position = (pos - Vector2(size.x / 2.0, 0.0)).clamp(Vector2(0.0, 0.0), Vector2(view_size.x - size.x, view_size.y - size.y))

func close() -> void:
	for child in container.get_children():
		container.remove_child(child)
	_list = []
	InputManager.main.set_hovering(null)
	visible = false
