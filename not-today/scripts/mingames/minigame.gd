extends Node2D
class_name Minigame

signal minigame_completed


func start_minigame() -> void:
	# Override this in subclasses
	push_error("start_minigame() not implemented!")

func finish_minigame():
	minigame_completed.emit()
