extends Minigame
class_name BrushTeethMG

@onready var dirts = $Dirts

var game_manager 

# Load the custom images for the mouse cursor.
var arrow = load("res://assets/BrushTeethMG/toothbrush_crop.png")
var cleaned_list : Array[Dirt]
var dirt_counter : int
var sound = "res://assets/Sounds/Brushing Teeth_1.mp3"

var annoying_flag = false

func _ready():	
	# Changes only the arrow shape of the cursor.
	# This is similar to changing it in the project settings.
	Input.set_custom_mouse_cursor(arrow)
	
	dirt_counter = dirts.get_children().size()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_minigame() -> void:
	#TODO
	pass

var m: Mutex = Mutex.new()

func clean_dirt(dirt: Dirt):
	if(cleaned_list.find(dirt) == -1):
		cleaned_list.append(dirt)
		dirt.queue_free()
		$AudioStreamPlayer.play()

		if(cleaned_list.size() == dirt_counter && m.try_lock()):
			Input.set_custom_mouse_cursor(null)
			finish_minigame()
			annoying_flag = true
