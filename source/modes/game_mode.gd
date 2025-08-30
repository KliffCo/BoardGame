class_name GameMode
extends Resource

static var main: GameMode

@export_file("*.tscn") var _char_slot_file
var _char_slot_prefab: Resource = null
var _last_chr_to_act: Controllable = null
var _rng: RandomNumberGenerator = RandomNumberGenerator.new()

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
	_rng.randomize()

func load_map() -> void:
	pass

func map_loaded() -> void:
	pass

#func try_control(sel: Selectable) -> void:
	#if not sel or can_control(sel):

func can_control(sel: Selectable) -> bool:
	var chr = sel as Char
	if chr:
		return chr.is_alive()
	return false

func controlling_changed() -> void:
	var con := InputManager.main.controlling
	if con:
		var selectables := con.get_selectables()
		InputManager.main.set_selectables(selectables)
	else:
		InputManager.main.set_selectables([])

func do_action(con: Controllable, action: Callable) -> void:
	_last_chr_to_act = con
	InputManager.main.pause()
	InputManager.main.set_selectables([]);
	InputManager.main.set_controlling(null)
	action.call(func():
		InputManager.main.resume()
		InputManager.main.set_controlling(con)
		action_finished()
	)

func on_char_moved() -> void:
	pass

func on_char_died() -> void:
	pass

func action_finished() -> void:
	turn_finished()

func turn_finished() -> void:
	pass

func end_game() -> void:
	pass
