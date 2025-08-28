class_name LSActionSelect
extends GameAction

func get_selectables(chr: Char) -> Array[ActionSelectable]:
	var list : Array[ActionSelectable] = []
	list.append(ActionSelectable.new(chr, self, Colors.SLOT_SELECTED));
	return list

func invoke(_chr: Char, _act: ActionSelectable) -> void:
	pass
	#GameMode.main.do_action(_act, func(callback: Callable):
		#var sync = 2
		#_chr.anim.play_once(Char.Action.Attack, func():
			#_chr.anim.set_action(Char.Action.Idle)
			#target.try_damage(1, _chr, func(_did_hit: bool):
				#callback.call()
			#)
		#)
	#)
