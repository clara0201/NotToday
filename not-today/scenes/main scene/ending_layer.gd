extends CanvasLayer

@onready var end_scren = $EndTitle
@onready var steward = $StewardScreen
@onready var queen = $QueenScreen
@onready var king = $KingScreen
@onready var final = $"Final screen"

var index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if(event is InputEventMouseButton and event.pressed):
		next_slide()

func next_slide():
	
	print(index)
	match index:
		2:
			king.visible = true
		3:
			queen.visible = true
		4:
			steward.visible = true
		5:
			final.visible = true
	index += 1
