class_name CharData
extends Resource

@export var name: String
@export var sprites: String
@export_file("*.tres") var _action_files: Array[String] = []
var _loaded = false
var _actions : Array[GameAction] = []

var actions: Array[GameAction]:
	get:
		if not _loaded:
			for file in _action_files:
				_actions.append(load(file))
		return _actions

#@export var actions: Array[GameAction] = []
	#set(new_value):
		#for i in range(new_value.size()):
			#if new_value[i] is not GameAction:
				#new_value[i] = GameAction.new()
				#new_value[i].init(i)
		#actions = new_value
