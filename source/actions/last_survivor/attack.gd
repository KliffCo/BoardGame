class_name LSActionAttack
extends GameAction

@export var min_range:= 0
@export var max_range:= 0

#func get_color() -> Color:
	#return Colors.CHAR_ATTACKABLE_ENEMY

func get_selectables(con: Controllable) -> Array[ActionSelectable]:
	var chr = con as Char
	if not chr:
		return []
	var list : Array[ActionSelectable] = []
	var rooms := RoomManager.main.rooms
	var start = rooms.find(chr.room)
	var distances := RoomManager.main.get_distance_array(start)

	for i in range(rooms.size()):
		var room := rooms[i]
		var distance := distances[i]
		if distance <= max_range && distance >= min_range:
			for slot in room.char_slots:
				if slot.character && slot.character != chr && slot.character.is_alive():
					var action_sel := ActionSelectable.new(slot.character, self, Colors.CHAR_ATTACKABLE_ENEMY)
					list.append(action_sel);
	return list

func invoke(con: Controllable, act: ActionSelectable) -> void:
	var chr = con as Char
	if not chr:
		return
	var target := act.selectable as Char
	if target:
		GameMode.main.do_action(act, func(callback: Callable):
			chr.anim.play_once(Char.Action.Attack, func():
				chr.anim.set_action(Char.Action.Idle)
				target.try_damage(1, chr, func(_did_hit: bool):
					callback.call()
				)
			)
		)
