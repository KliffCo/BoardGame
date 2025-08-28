class_name ActionMenu
extends Control

static var main : ActionMenu
var container: VBoxContainer
var prefab: ActionMenuButton = null
var _list: Array[ActionSelectable] = []

func _ready() -> void:
	main = self
	container = find_child("container")
	prefab = container.get_child(0)
	hide_list()

func show_list(pos: Vector2, chr: Char, list: Array[ActionSelectable]) -> void:
	hide_list()
	InputManager.main.can_select = false
	_list = list
	for act in _list:
		var cell = prefab.duplicate() as ActionMenuButton
		container.add_child(cell)
		cell.set_owner(self)
		var x = cell.get_owner()
		cell.setup(chr, act)
	visible = true
	var cell_size:= prefab.get_rect().size
	size = Vector2(cell_size.x, cell_size.y * _list.size())
	position = pos
	#node.get_rect().size

func hide_list() -> void:
	for child in container.get_children():
		container.remove_child(child)
	_list = []
	visible = false
	if InputManager.main:
		InputManager.main.can_select = true
