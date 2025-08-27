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

func _init() -> void:
	main = self

func load_map() -> void:
	pass

func map_loaded() -> void:
	pass

func try_select_char(chr: Char) -> bool:
	if not chr || (chr && chr.is_alive):
		CharManager.main.select(chr)
		return true
	return false

func char_selected() -> void:
	var chr := CharManager.main.selected
	if chr:
		var selectables := chr.get_selectables()
		InputManager.main.set_selectables(selectables)
	else:
		InputManager.main.set_selectables([])

func do_action(act: ActionSelectable, action: Callable) -> void:
	InputManager.main.pause()
	InputManager.main.set_selectables([act]);
	CharManager.main.hide_selection();
	action.call(func():
		InputManager.main.resume()
		if CharManager.main.selected:
			CharManager.main.select(CharManager.main.selected)
			action_finished()
	)

func action_finished() -> void:
	turn_finished()

func turn_finished() -> void:
	pass
