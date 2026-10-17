extends Node2D
class_name GameManager

@onready var minigames_window = $MinigamesWindow
@onready var timer = $Timer
@onready var likeability_label = $CanvasLayer/CountersMC/HBoxContainer/LikeabilityLabel
@onready var likeability_icon = $CanvasLayer/CountersMC/HBoxContainer/LikeabilityIcon
@onready var no_label = $CanvasLayer/CountersMC/HBoxContainer/NosLabel
@onready var no_icon = $CanvasLayer/CountersMC/HBoxContainer/NosIcon
@onready var timer_label = $CanvasLayer/TimerMC/TimerLabel

@export var likeability_percentage = 30
@export var likeability_loss = 10
@export var likeability_gain = 5

@export var no_counter = 0
@export var progress_to_no = 0
@export var no_threshold = 2

@export var minigames_timer = 5 # in seconds

@export var tasks_list : Array[TaskResource]
@export var current_task_index = 0
@export var current_minigame : Minigame

var current_day = 1
var in_minigame_phase = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(in_minigame_phase):
		timer_label.text = "%02d:%02d" % time_left()

	if Input.is_action_pressed("MinigamePhase"):
		start_minigame_phase()

func time_left():
	var time_left = timer.time_left
	var minute = floor(time_left / 60)
	var second = int(time_left) % 60
	return [minute, second]

### MINIGAMES ###

func start_minigame_phase():
	#TODO pause player controller
	
	minigames_window.position.x = 400
	minigames_window.position.y = 160
	minigames_window.show()
	
	in_minigame_phase = true
	timer_label.show()
	
	timer.start(minigames_timer)
	
	next_minigame()

func finish_minigame_phase():	
	for task in tasks_list:
		if not task.completed:
			on_minigame_not_completed(task)
	
	update_displays() #TBD maybe do a special sequence to recount the incompleted tasks
	
	in_minigame_phase = false
	timer_label.hide()
	
	minigames_window.hide()
	
	#TODO start second day

func next_minigame():	
	if(current_task_index >= tasks_list.size()):
		finish_minigame_phase()
		return
	
	var task = tasks_list[current_task_index]
	
	if(task.minigame_scene == null):
		push_error("No minigame scene assigned to task!")
	
	current_minigame = task.minigame_scene.instantiate() as Minigame
	
	minigames_window.add_child(current_minigame)
	current_minigame.minigame_completed.connect(on_minigame_completed)

	current_minigame.start_minigame()

func on_minigame_not_completed(task: TaskResource) -> void:
	progress_to_no += 1
	if(progress_to_no == no_threshold):
		no_counter += 1
		progress_to_no  = 0
	
	likeability_percentage =- likeability_loss
	tasks_list[current_task_index].completed = false

func on_minigame_completed() -> void:
	likeability_percentage += likeability_gain
	tasks_list[current_task_index].completed = true
	
	update_displays()
	
	if is_instance_valid(current_minigame):
		current_minigame.queue_free()
		current_minigame = null
	
	current_task_index += 1
	next_minigame()

func update_displays() -> void:	
	likeability_label.text = "Likeability: " + str(likeability_percentage) + "%"
	no_label.text = "No's: " + str(no_counter)


### SIGNALS ###

func _on_timer_timeout() -> void:
	finish_minigame_phase()
