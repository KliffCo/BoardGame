class_name ActionMenuCell
extends Button

var _con: Controllable
var _act: ActionSelectable

func setup(con: Controllable, act: ActionSelectable):
	_con = con
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
				var do_action = get_global_rect().has_point(e.global_position)
				ActionMenu.main.close()
				if do_action:
					_con.invoke_action(_act)
			MOUSE_BUTTON_RIGHT:
				ActionMenu.main.close()
		viewport.set_input_as_handled()
