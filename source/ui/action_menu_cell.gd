class_name ActionMenuCell
extends Button

signal left_click

var _chr: Char
var _act: ActionSelectable

func setup(chr: Char, act: ActionSelectable):
	_chr = chr
	_act = act
	#var btn = find_child("button", false, false)
	#btn.text = act.action.name
	text = act.action.name

func _ready() -> void:
	gui_input.connect(_on_gui_input)

func _on_gui_input(e: InputEvent) -> void:
	if e is InputEventMouseButton and not e.pressed:
		var viewport = get_viewport()
		match e.button_index:
			MOUSE_BUTTON_LEFT:
				ActionMenu.main.close()
				if get_rect().has_point(e.position):
					_chr.invoke_action(_act)
			MOUSE_BUTTON_RIGHT:
				ActionMenu.main.close()
		viewport.set_input_as_handled()
