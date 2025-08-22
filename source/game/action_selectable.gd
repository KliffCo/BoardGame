class_name ActionSelectable

var selectable: Selectable
var action: GameAction
var color: Color;

func _init(_selectable: Selectable, _action: GameAction, _color: Color):
	selectable = _selectable
	action = _action
	color = _color
