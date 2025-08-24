class_name CharAnimator
extends Node

const FPS := 15
const FRAME_TIME := 1.0/FPS

var _frames: CharFrames = null
var _action: Char.Action = Char.Action.Idle
var _frame: int = 0
var _next_frame: float = 0
var _action_callback: Callable = Null.CALLABLE

var _char: Char:
	get: return get_parent() as Char

func load(_name: String) -> void:
	_frames = CharFrames.new(_name)
	_char.mesh.set_shadow_texture(_frames.get_shadow())
	set_action(_action)
	set_frame(_frame)

func set_action(action: Char.Action, force: bool = false) -> void:
	if _char == null:
		_action = action
		return
	if _action != action || force:
		_action = action
		set_frame(0)

func play_once(action: Char.Action, callback: Callable) -> void:
	_action_callback = callback
	set_action(action, true)

func set_frame(frame: int) -> void:
	_next_frame = FRAME_TIME
	if _frames == null:
		return
	var frame_count = _frames.get_frame_count(_action)
	if frame_count == 0:
		return
	_frame = frame % frame_count
	var tex = _frames.get_texture(_action, _frame)
	_char.mesh.set_stand_texture(tex)

func _process(delta: float) -> void:
	_next_frame -= delta
	if _next_frame <= 0:
		if _action_callback != Null.CALLABLE && _frame+1 == _frames.get_frame_count(_action):
			var callback = _action_callback
			_action_callback = Null.CALLABLE
			callback.call()
		else:
			set_frame(_frame + 1)
