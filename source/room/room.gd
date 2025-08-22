class_name Room
extends Selectable

#static var _char_slot_prefab = preload("res://rooms/components/room_char_slot.tscn")

var _tile: RoomTile
var grid_list: Array[Vector2i] = []

var exits: Array[RoomExit] = []
var unused_exits: Array[RoomExit] = []

var _model: Node3D = null

var _char_slot_holder: Node3D = null
var _char_slots: Array[RoomCharSlot] = []
var _ground_mesh: MeshInstance3D = null
var _ground_mat: ShaderMaterial = null

var grid_pos: Vector2i:
	get: return grid_list[0]

func _init(index:int, tile: RoomTile, pos: Vector2i):
	name = "Room"+str(index)
	_tile = tile
	grid_list.append(pos)
	position = Vector3i(pos.x, 0, pos.y)
	add_child(tile)
	set_angle(0)

func set_angle(angle: int) -> void:
	exits = []
	unused_exits = []
	for src in _tile.exits:
		var e = RoomExit.new()
		e.name = src.name
		e.position = grid_pos + src.position
		e.direction = src.direction
		unused_exits.append(e)

func build_model() -> void:
	if _tile.get_child_count() > 0:
		_model = _tile.get_child(0)
	else:
		pass # todo build fbx
	_init_char_slots()

func _init_char_slots() -> void:
	if not GameMode.main.has_char_slots():
		return
	_char_slot_holder = Node3D.new()
	_char_slot_holder.name = "Char Slots"
	_char_slot_holder.position = Vector3(0, MeshGen.SPACING*2, 0)
	add_child(_char_slot_holder)
	for c in _model.get_children(false):
		if c.name.begins_with("CharSlot_"):
			var slot: RoomCharSlot = GameMode.main.new_char_slot(c)
			_char_slots.append(slot)
			_char_slot_holder.add_child(slot)

func find_unused_exit(pos: Vector2i, dir: Vector2i) -> int:
	for i in range(unused_exits.size()):
		var e = unused_exits[i]
		if e.position == pos and e.direction == dir:
			return i
	return -1

func use_exit(index: int, room: Room) -> void:
	var exit = unused_exits[index]
	exit.room = room
	exits.append(exit)
	unused_exits.remove_at(index)
	if _model == null:
		build_model()
	var nodes: Array[Node] = _model.find_children("Wall"+exit.name+"_*", "", false, false)
	for n in nodes:
		n.visible = false

func is_in_grid(pos: Vector2i) -> bool:
	return grid_list.find(pos) != -1

func has_empty_slot() -> bool:
	for slot in _char_slots:
		if slot.is_empty:
			return true
	return false

func get_empty_slots() -> Array[RoomCharSlot]:
	var slots: Array[RoomCharSlot] = []
	for s in _char_slots:
		if not s.character:
			slots.append(s)
	return slots

func _update_selectable() -> void:
	if _is_selectable:
		if not _ground_mesh:
			_init_ground_mesh()
		_ground_mat.set_shader_parameter("outline_color", _selectable_color)
		_ground_mesh.visible = true
	else:
		if _ground_mesh:
			_ground_mesh.visible = false

func _init_ground_mesh() -> void:
	var ground = _model.find_child("Ground") as MeshInstance3D
	_ground_mesh = MeshInstance3D.new()
	_ground_mesh.visible = false
	_ground_mesh.name = "Ground_Outline"
	_ground_mesh.transform = ground.transform
	_ground_mesh.mesh = ground.mesh
	_ground_mat = RoomManager.main.new_outline_material()
	var src_mat = ground.get_active_material(0) as BaseMaterial3D
	_ground_mat.set_shader_parameter("tex_albedo", src_mat.albedo_texture)
	_ground_mesh.material_override = _ground_mat
	_model.add_child(_ground_mesh)
