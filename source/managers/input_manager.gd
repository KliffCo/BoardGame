class_name InputManager
extends Node3D

static var main: InputManager

var _enabled = true
var _can_pan = true
var _can_click = true

var _is_clicking:= false
var _is_panning:= false
var _grip_position: Vector3
var _selectables:Array[ActionSelectable] = []
var _colliders:Array[PhysicsBody3D] = []
var _hovering: Selectable = null
var _controlling: Controllable = null
var _select_action: ActionSelect = ActionSelect.new()
var _mouse_pos: Vector2
var _mouse_touchdown_pos: Vector2

const CLICK_THRESHOLD = 10

var controlling: Controllable:
	get: return _controlling

func _ready() -> void:
	main = self

func _input(e: InputEvent) -> void:
	if e is InputEventMouse:
		_mouse_pos = e.position

func _unhandled_input(e: InputEvent) -> void:
	if not _enabled:
		return
	if e is InputEventMouse:
		mouse_pan(e)
		mouse_click(e)

func mouse_pan(e: InputEventMouse) -> void:
	if not _can_pan:
		return
	if e is InputEventMouseButton:
		if e.button_index == MOUSE_BUTTON_WHEEL_UP:
			CameraManager.main.set_desired_zoom(CameraManager.main.get_desired_zoom()+0.1)
		elif e.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			CameraManager.main.set_desired_zoom(CameraManager.main.get_desired_zoom()-0.1)
		else: #if e.button_index == MOUSE_BUTTON_RIGHT or e.button_index == MOUSE_BUTTON_MIDDLE:
			if e.pressed:
				var world_pos = CameraManager.main.screen_to_world_pos(e.position)
				if world_pos is Vector3:
					_is_panning = true
					_grip_position = world_pos
			else:
				_is_panning = false
	elif e is InputEventMouseMotion:
		if _is_panning:
			var world_pos = CameraManager.main.screen_to_world_pos(e.position)
			if world_pos is Vector3:
				CameraManager.main.set_desired_pan(CameraManager.main.get_actual_pan()-world_pos+_grip_position)

func mouse_click(e: InputEventMouse) -> void:
	if not _can_click:
		return
	if e is InputEventMouseButton:
		if e.pressed:
			_is_clicking = true
			_mouse_touchdown_pos = e.position
		if e.button_index == MOUSE_BUTTON_LEFT:
			if not e.pressed and _is_clicking:
				if _hovering:
					var acts := get_actions_for(_hovering)
					if _hovering is Controllable and GameMode.main.can_control(_hovering):
						acts.insert(0, ActionSelectable.new(_hovering, _select_action, Colors.CHAR_SELECTED))
					else:
						var con = get_controllable_at_point(e.position)
						if con:
							acts.insert(0, ActionSelectable.new(con, _select_action, Colors.CHAR_SELECTED))
					_is_panning = false
					ActionMenu.main.open(e.position, InputManager.main.controlling, acts)
				else:
					set_controlling(get_controllable_at_point(e.position))
		if e.button_index == MOUSE_BUTTON_RIGHT:
			if not e.pressed and _is_clicking:
				set_controlling(null)
		if not e.pressed:
			_is_clicking = false
	elif e is InputEventMouseMotion:
		if _is_clicking:
			if (e.position - _mouse_touchdown_pos).length_squared() > CLICK_THRESHOLD*CLICK_THRESHOLD:
				_is_clicking = false
		update_hovering(e.position)

func get_controllable_at_point(pos: Vector2) -> Controllable:
	var hits: Array = CameraManager.main.colliders_at_screen_pos(pos, Colliders.CHAR_MASK)
	for hit in hits:
		var col = hit.collider as StaticBody3D
		var con = col.get_parent_node_3d() as Controllable
		if con && GameMode.main.can_control(con):
			return con
	return null

func set_controlling(con: Controllable) -> void:
	ActionMenu.main.close()
	if _controlling:
		_controlling.set_controlling(false)
	_controlling = con
	if _controlling:
		_controlling.set_controlling(true)
	GameMode.main.controlling_changed()

#func hide_controlling() -> void:
	#if _controlling:
		#_controlling.set_controlling(false)

func set_selectables(list: Array[ActionSelectable]) -> void:
	for sel:ActionSelectable in _selectables:
		if sel.selectable != InputManager.main.controlling:
			sel.selectable.set_stroke(false, Color.TRANSPARENT)
			sel.selectable.set_fill(false, Color.TRANSPARENT)
	_selectables = list
	_colliders.clear()
	_hovering = null
	for sel:ActionSelectable in _selectables:
		sel.selectable.set_stroke(true, sel.color)
		var col:= sel.selectable.collider
		if _colliders.find(col) == -1:
			_colliders.append(col)
	update_hovering(_mouse_pos)

func update_hovering(_position: Vector2):
	if len(_colliders) > 0:
		var hit := CameraManager.main.collider_at_screen_pos_in(_position, _colliders)
		var sel: Selectable = null
		if hit:
			var index = _colliders.find(hit.collider as PhysicsBody3D)
			if index != -1:
				sel = _selectables[index].selectable
		set_hovering(sel)

func set_hovering(value: Selectable) -> void:
	if _hovering == value:
		return
	_hovering = value
	for sel:ActionSelectable in _selectables:
		if sel.selectable == _hovering:
			sel.selectable.set_fill(true, Color.WHITE);
		else:
			sel.selectable.set_fill(false, Color.TRANSPARENT);

func get_actions_for(sel) -> Array[ActionSelectable]:
	var list: Array[ActionSelectable] = []
	for act in _selectables:
		if act.selectable == sel:
			list.append(act)
	return list

func pause() -> void:
	_can_click = false

func resume() -> void:
	_can_click = true
