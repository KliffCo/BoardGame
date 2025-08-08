class_name CharAnimator
extends Resource

const FPS := 10
const FRAME_TIME := 1.0/FPS

var char: Character = null
var frames: CharFrames = null
var action: Char.Action = Char.Action.Idle
var frame: int = 0
var next_frame: float = 0

func _init(char: Node3D):
	self.char = char

func load(name: String):
	frames = CharFrames.new(name)
	char.mesh.set_shadow_texture(frames.get_shadow())
	set_action(action)
	set_frame(frame)

func set_action(action: Char.Action):
	if char == null:
		self.action = action
		return
	if self.action != action:
		self.action = action
		set_frame(0)

func set_frame(frame: int):
	next_frame = FRAME_TIME
	if frames == null:
		return
	var frame_count = frames.get_frame_count(action)
	if frame_count == 0:
		return
	self.frame = frame % frame_count
	var tex = frames.get_texture(action, self.frame)
	char.mesh.set_stand_texture(tex)

func process(delta: float) -> void:
	next_frame -= delta
	if next_frame <= 0:
		set_frame(frame + 1)
	
