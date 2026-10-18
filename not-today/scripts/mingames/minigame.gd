extends Node2D
class_name Minigame

signal minigame_completed


func start_minigame() -> void:
	# Override this in subclasses
	push_error("start_minigame() not implemented!")

func finish_minigame():
	print("finished!")
	minigame_completed.emit()

func incomplete_minigame():
	# Override this in subclasses
	push_error("incomplete_minigame() not implemented!")
