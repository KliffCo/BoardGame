class_name GameMode
extends Resource

static var main: GameMode = null

@export_file("*.tscn") var _char_slot_file
var _char_slot_prefab: Resource = null
var _last_chr_to_act: Controllable = null
var _rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _init() -> void:
	main = self
	_rng.randomize()

func _init_char_sets() -> void:
	pass

func get_player_limit() -> int:
	return 4

func turn_order_style() -> TurnOrder.Style:
	return TurnOrder.Style.None

func has_bots() -> bool:
	return false

func new_bot() -> BotPlayer:
	return null

func has_char_slots() -> bool:
	if _char_slot_file == null:
		return false
	if not _char_slot_prefab:
		_char_slot_prefab = load(_char_slot_file)
		if _char_slot_prefab == null:
			_char_slot_file = null
	return _char_slot_prefab != null

func new_char_slot(node: Node3D, id) -> RoomCharSlot:
	var slot = _char_slot_prefab.instantiate()
	slot.id = id
	slot.name = "slot_"+str(id)
	slot.position = node.position# + Vector3(0, 0.01, 0)
	return slot

func load_map() -> void:
	pass

func start_game() -> void:
	pass

func can_control(con: Controllable) -> bool:
	var chr = con as Char
	if chr:
		return chr.is_alive()
	return false

func controlling_changed() -> void:
	var con := InputManager.main.controlling
	if con and Lobby.main.is_my_turn():
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
		action_finished()
		InputManager.main.set_controlling(con)
	)

func on_char_moved() -> void:
	pass

func on_char_died() -> void:
	pass

func turn_started() -> void:
	pass

func action_finished() -> void:
	turn_finished()

func turn_finished() -> void:
	pass

func end_game() -> void:
	pass

func random_int_list(size: int, rng: RandomNumberGenerator = null) -> Array[int]:
	var list : Array[int] = []
	list.resize(size)
	for i in range(size):
		list[i] = i
	if rng == null:
		rng = RandomNumberGenerator.new()
		rng.randomize()
	var temp: int
	for i in range(size - 1, 0, -1):
		var j = rng.randi() % (i + 1)
		temp = list[i]
		list[i] = list[j]
		list[j] = temp
	return list
