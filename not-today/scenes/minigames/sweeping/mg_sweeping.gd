extends Minigame

@onready var sweep = $Sweep
@onready var dirt_group = $Dirts
@onready var animationPlayer = $AnimationPlayer

var dirt_list : Array[Node]
var total_dirt : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dirt_list = dirt_group.get_children()
	total_dirt = dirt_list.size()
	
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
	animationPlayer.play("sweeping")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		sweep.position = event.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_sweep_area_2d_area_entered(area: Area2D) -> void:
	for d in dirt_list:
		if(d.get_node("Area2D") == area):
			dirt_list.erase(d)
			d.queue_free()
			$AudioStreamPlayer.play()
			
			if(dirt_list.size() == 0):
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
				finish_minigame()
