class_name CharFrames
extends Resource

static var _PATH = "res://char_images/"
static var _keys = null
var _shadow: Texture2D
var _textures: Array = []

func _init(name: String):
	if _keys == null:
		_keys = Char.Action.keys()
		for i in range(_keys.size()):
			_keys[i] = _keys[i].to_lower()
	_textures.resize(_keys.size())
	for i in range(_keys.size()):
		_textures[i] = []
	
	var path = _PATH+name
	var dir = DirAccess.open(path)
	if dir:
		for file in dir.get_files():
			if file.ends_with(".png"):
				var tex: Texture2D = load(path+"/"+file)
				if tex != null:
					for i in range(_keys.size()):
						if file.begins_with(_keys[i]):
							_textures[i].append(tex)
					if file.begins_with("shadow"):
						_shadow = tex

func get_frame_count(action: Char.Action) -> int:
	var a = int(action)
	if a < 0 or a >= _textures.size():
		return 0
	return _textures[a].size()

func get_texture(action: Char.Action, frame: int) -> Texture2D:
	var a = int(action)
	if a < 0 or a >= _textures.size():
		return null
	if frame < 0 or frame >= _textures[a].size():
		return null
	return _textures[a][frame]

func get_shadow() -> Texture2D:
	return _shadow
