class_name CharAnimator
extends Node

const FPS := 10
const FRAME_TIME := 1.0/FPS

var _frames: CharFrames = null
var _action: Char.Action = Char.Action.Idle
var _frame: int = 0
var _next_frame: float = 0

var _char: Char:
	get: return get_parent() as Char

func load(name: String):
	_frames = CharFrames.new(name)
	_char.mesh.set_shadow_texture(_frames.get_shadow())
	set_action(_action)
	set_frame(_frame)

func set_action(action: Char.Action):
	if char == null:
		_action = action
		return
	if _action != action:
		_action = action
		set_frame(0)

func set_frame(frame: int):
	_next_frame = FRAME_TIME
	if _frames == null:
		return
	var frame_count = _frames.get_frame_count(_action)
	if frame_count == 0:
		return
	_frame = frame % frame_count
	var tex = _frames.get_texture(_action, _frame)
	_char.mesh.set_stand_texture(tex)

func process(delta: float) -> void:
	_next_frame -= delta
	if _next_frame <= 0:
		set_frame(_frame + 1)
	
