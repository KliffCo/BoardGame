class_name LastSurvivorBot
extends BotPlayer

func turn_started() -> void:
	super.turn_started()
	await GameManager.main.get_tree().create_timer(0.1).timeout
	GameMode.main.turn_finished()
