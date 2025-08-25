class_name InputManager
extends Node3D

static var main: InputManager

var _enabled = true
var _is_panning:= false
var _grip_position: Vector3
var _selectables:Array[ActionSelectable] = []
var _colliders:Array[PhysicsBody3D] = []
var _is_dragging: = false
var _proposed_selectable: Selectable = null

func _ready() -> void:
	main = self

func _input(e: InputEvent) -> void:
	if not _enabled:
		return
	if e is InputEventMouse:
		mouse_input(e)

func mouse_input(e: InputEventMouse):
	if e is InputEventMouseButton:
		if e.button_index == MOUSE_BUTTON_WHEEL_UP:
			CameraManager.main.set_desired_zoom(CameraManager.main.get_desired_zoom()+0.1)
		elif e.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			CameraManager.main.set_desired_zoom(CameraManager.main.get_desired_zoom()-0.1)
		elif e.button_index == MOUSE_BUTTON_RIGHT or e.button_index == MOUSE_BUTTON_MIDDLE:
			if e.pressed:
				var world_pos = CameraManager.main.screen_to_world_pos(e.position)
				if world_pos is Vector3:
					_is_panning = true
					_grip_position = world_pos
			else:
				_is_panning = false
		elif e.button_index == MOUSE_BUTTON_LEFT:
			if e.pressed:
				var hits: Array = CameraManager.main.colliders_at_screen_pos(e.position, Colliders.CHAR_MASK)
				var selected = false
				for hit in hits:
					var col = hit.collider as StaticBody3D
					var chr = col.get_parent_node_3d() as Char
					if chr && GameMode.main.try_select_char(chr):
						selected = true
						break
				if selected:
					_is_dragging = true
				else:
					GameMode.main.try_select_char(null)
			else:
				if _is_dragging && CharManager.main.selected:
					_is_dragging = false
					var hits: Array = CameraManager.main.colliders_at_screen_pos(e.position)
					for hit in hits:
						var col = hit.collider as StaticBody3D
						var act = find_selectable(col.get_parent_node_3d() as Selectable)
						if act:
							CharManager.main.selected.invoke_action(act.action, act.selectable)
							break
	elif e is InputEventMouseMotion:
		if _is_panning:
			var world_pos = CameraManager.main.screen_to_world_pos(e.position)
			if world_pos is Vector3:
				CameraManager.main.set_desired_pan(CameraManager.main.get_actual_pan()-world_pos+_grip_position)
		if _is_dragging:
			var hit := CameraManager.main.collider_at_screen_pos_in(e.position, _colliders)
			var sel: Selectable = null
			if hit:
				#var body: PhysicsBody3D = hit["collider"]
				var index = _colliders.find(hit.collider as PhysicsBody3D)
				if index != -1:
					sel = _selectables[index].selectable
			propose_selectable(sel)

func set_selectables(list: Array[ActionSelectable]) -> void:
	for sel:ActionSelectable in _selectables:
		if sel.selectable != CharManager.main.selected:
			sel.selectable.unset_selectable()
	_selectables = list
	_colliders.clear()
	_proposed_selectable = null
	for sel:ActionSelectable in _selectables:
		sel.selectable.set_selectable_color(sel.color)
		var col:= sel.selectable.get_collider()
		if _colliders.find(col) != -1:
			_colliders.append(col)

func find_selectable(sel) -> ActionSelectable:
	for act in _selectables:
		if act.selectable == sel:
			return act
	return null

func propose_selectable(b: Selectable):
	if _proposed_selectable == b:
		return
	_proposed_selectable = b
	for sel:ActionSelectable in _selectables:
		if _proposed_selectable && sel.selectable != _proposed_selectable:
			sel.selectable.set_selectable_color(Color(sel.color, 0.1))
		else:
			sel.selectable.set_selectable_color(sel.color)

func pause() -> void:
	_enabled = false

func resume() -> void:
	_enabled = true
