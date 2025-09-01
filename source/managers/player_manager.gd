#class_name PlayerManager
#extends Control
#
#static var main: PlayerManager = null
#const NODE_PADDING := 5.0
#
#var horizontal:= true
#var prefab: PlayerUI = null
#
#func _ready() -> void:
	#main = self
	#prefab = get_child(0)
	#remove_child(prefab)
#
#func init_player(p: Player) -> void:
	#p.node = prefab.duplicate() as PlayerUI
	#add_child(p.node)
	#p.node.set_owner(self)
	#p.node.name = "player_"+str(p.id)
	#p.node.set_player(p)
	#sort_nodes(true)
#
#func on_size_changed() -> void:
	#sort_nodes(false)
#
#func sort_nodes(_animate: bool) -> void:
	#if list.size() == 0:
		#return
	#var dir := Vector2(1.0, 0.0) if horizontal else Vector2(0.0, 1.0)
	#var step := (list[0].node.get_rect().size + Vector2(NODE_PADDING, NODE_PADDING)) * dir
	#var offset := Vector2(step.x * list.size() - NODE_PADDING, step.x * list.size() - NODE_PADDING) * Vector2(-0.5, -0.5) * dir
	#
	#for i in range(list.size()):
		#var node: PlayerUI = list[i].node
		#node.position = i*step+offset
