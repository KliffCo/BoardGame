class_name GameMode
extends Resource

static var main: GameMode

@export_file("*.tscn") var _char_slot_file
var _char_slot_prefab: Resource = null

func has_char_slots() -> bool:
	if _char_slot_file == null:
		return false
	if not _char_slot_prefab:
		_char_slot_prefab = load(_char_slot_file)
		if _char_slot_prefab == null:
			_char_slot_file = null
	return _char_slot_prefab != null

func new_char_slot(node: Node3D) -> RoomCharSlot:
	var slot = _char_slot_prefab.instantiate()
	slot.name = node.name
	slot.position = node.position# + Vector3(0, 0.01, 0)
	return slot

func _init():
	main = self

func load_map():
	pass

func map_loaded():
	pass

#func can_select_char(chr: Char):
	#return true

func on_select_char(chr: Char):
	CharManager.main.select(chr)
	return true

func do_action(action: Callable):
	InputManager.main.pause()
	action.call(func():
		InputManager.main.resume()
		if CharManager.main.selected:
			on_select_char(CharManager.main.selected)
	)
