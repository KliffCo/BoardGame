class_name LSYourCharsPopup
extends Control

@export var container: Container
@onready var anim : AnimationPlayer = $AnimationPlayer
var _closing := false

func _ready() -> void:
	visible = false
	set_process(false)

func open_popup() -> void:
	visible = true
	set_process(true)
	_closing = false
	update_chars()
	anim.play("blur")

func close_popup() -> void:
	_closing = true
	anim.play_backwards("blur")
	var anim :Animation = anim.get_animation("blur")
	await get_tree().create_timer(anim.length).timeout
	visible = false
	set_process(false)
	#get_parent().remove_child(self)

func update_chars() -> void:
	for cell in container.get_children():
		if cell is Control:
			cell.visible = false
	var first := container.get_child(0)
	var chars := Lobby.main.me.get_my_chars()
	var child_count := container.get_child_count()
	for i in range(chars.size()):
		var cell: Control
		if i < child_count:
			cell = container.get_child(i)
		else:
			cell = first.duplicate(true)
			container.add_child(cell)
		cell.visible = true
		var chr := chars[i]
		var image := cell.get_child(1) as TextureRect
		var path = Char.IMAGE_PATH+chr.data.name+"/portrait.png"
		var tex: Texture2D = load(path)
		image.texture = tex
	for i in range(child_count-1, max(1, chars.size())-1, -1):
		remove_child(get_child(i))

func _input(e: InputEvent) -> void:
	if _closing:
		return
	if e is InputEventMouseButton:
		if e.button_index == MOUSE_BUTTON_LEFT and not e.pressed:
			close_popup()
