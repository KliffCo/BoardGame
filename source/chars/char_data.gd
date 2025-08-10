class_name CharData
extends Resource

@export var name: String
@export var sprites: String
@export_file("*.tres") var actions: Array[String] = []
#@export var actions: Array[GameAction] = []
	#set(new_value):
		#for i in range(new_value.size()):
			#if new_value[i] is not GameAction:
				#new_value[i] = GameAction.new()
				#new_value[i].init(i)
		#actions = new_value
