class_name MapSettings
extends Resource

@export_file("*.tscn") var file: String
@export_file("*.tres") var tile_set: String
@export var seed: int = 0
@export var rooms: int = 10
@export_range(1, 10) var extend_odds: float = 1.5
