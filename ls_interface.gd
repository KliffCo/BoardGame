class_name LSInterface
extends Control

static var main: LSInterface = null

@export var your_chars: LSYourCharsPopup

func _ready() -> void:
	main = self

func show_my_chars() -> void:
	your_chars.open_popup()
