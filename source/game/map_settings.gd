class_name MapSettings
extends Resource

@export_file("*.tscn") var file: String
@export_file("*.tscn") var _tile_set: String
@export var _seed: int
@export var _rooms: int = 10
@export_range(1, 10) var _extend_odds: float = 1.5
