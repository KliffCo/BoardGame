class_name RoomTile
extends Node3D

@export_subgroup("Shape")
@export var size: Vector2i = Vector2i.ONE
@export var exits: Array[Vector2i] = [] #Vector2i(0,-1), Vector2i(1,0), Vector2i(0,1), Vector2i(-1,0)]
