class_name RoomCharSlot
extends MeshInstance3D

static var _texture : Texture2D = load("res://game/images/char_slot.png")
static var _scale := Vector3(0.25, 1, 0.25)

var _mat: StandardMaterial3D
var _color: Color = Color.WHITE
var _changing: bool = false
var _char: Char = null

func _ready() -> void:
	scale = _scale
	mesh = MeshGen.plane()
	_mat = MeshGen.new_material(self)
	_mat.albedo_texture = _texture
	#set_color(Color.RED)

var character: Char:
	get: return _char
	set(value): _char = value

func set_color(color: Color, instant: bool = false):
	_color = color
	_changing = !instant
	if instant:
		_mat.albedo_color = color

func _process(delta: float) -> void:
	if not _changing:
		return
	if _mat.albedo_color != _color:
		_mat.albedo_color = _mat.albedo_color.lerp(_color, delta*3)
		var diff = _mat.albedo_color - _color
		if diff.r+diff.g+diff.b+diff.a < 0.05:
			_changing = false
