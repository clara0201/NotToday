extends Area2D
class_name Dirt

@export var minigame_main : BrushTeethMG

var flag = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mouse_entered() -> void:
	if(!flag):
		minigame_main.clean_dirt(self)
		flag = true
