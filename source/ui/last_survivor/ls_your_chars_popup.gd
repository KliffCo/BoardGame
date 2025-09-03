class_name LSYourCharsPopup
extends Control

@export var container: Container

func _ready() -> void:
	open_popup()

func open_popup() -> void:
	update_chars()
	visible = true
	$AnimationPlayer.play("blur")

func close_popup() -> void:
	$AnimationPlayer.play_backwards("blur")
	var anim :Animation = $AnimationPlayer.get_animation("blur")
	await get_tree().create_timer(anim.length).timeout
	visible = false

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
		var path = Char.IMAGE_PATH+name+"/portrait.png"
		var tex: Texture2D = load(path)
		image.texture = tex
		
