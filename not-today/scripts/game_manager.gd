extends Node2D
class_name GameManager

@onready var minigames_window = $MinigamesWindow
@onready var timer = $TimerMinigames
@onready var likeability_label = $UILayer/CountersMC/HBoxContainer/LikeabilityLabel
@onready var likeability_icon = $UILayer/CountersMC/HBoxContainer/LikeabilityIcon
@onready var no_label = $UILayer/CountersMC/HBoxContainer/NosLabel
@onready var no_icon = $UILayer/CountersMC/HBoxContainer/NosIcon
@onready var timer_label = $UILayer/TimerMC/TimerLabel
@onready var timer_container = $UILayer/TimerMC
@onready var fadeout_color_rect = $FadeoutLayer/ColorRect
@onready var animation_player = $FadeoutLayer/AnimationPlayer
@onready var day_over_layer = $DayOverLayer
@onready var day_label = $UILayer/TaskListMC/ScrollContainer/VBoxContainer/MarginContainer/DayLabel
@onready var end_layer = $EndingLayer
@onready var task_container = $UILayer/TaskListMC/ScrollContainer/VBoxContainer

@onready var npc_group = $npc_group
@onready var _dialogue_box: CanvasLayer = $DialogueBox

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

@export var total_days = 2

var ticket_scene = preload("res://scenes/task_ticket.tscn")

var current_day = 1
var in_minigame_phase = false

var day_completed_tasks : int
var day_incompleted_tasks : int
var day_won_nos : int

var day_names = ["Mondagt", "Tuesdlof", "Wednasgot"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect NPC interaction signals
	for npc in npc_group.get_children():
		npc.interacted.connect(_on_npc_interacted)
	
	_dialogue_box.choice_made.connect(create_task)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(in_minigame_phase):
		timer_label.text = "%02d:%02d" % time_left()

	if Input.is_action_just_released("MinigamePhase"):
		start_minigame_phase()

func time_left():
	var time_left = timer.time_left
	var minute = floor(time_left / 60)
	var second = int(time_left) % 60
	return [minute, second]

### DAYS ###

func end_day():
	fadeout_color_rect.visible = true
	animation_player.play("fade_to_black")
	
	await get_tree().create_timer(1.0).timeout
	
	if(current_day < total_days):
		day_over_layer.visible = true
		day_over_layer.initialize(day_completed_tasks, day_incompleted_tasks, likeability_percentage, day_won_nos)
	else:
		end_layer.visible = true

func start_day():
	day_over_layer.visible = false
	await get_tree().create_timer(0.5).timeout
	
	current_day +=1
	day_label.text = day_names[current_day-1]
	
	day_completed_tasks = 0
	day_incompleted_tasks = 0
	day_won_nos = 0
	
	tasks_list.clear()
	
	animation_player.play("fade_to_normal")
	
	#TODO 
	# - set NPC dialogue?
	# - move NPCs?
	# - set Player initial position
	

### MINIGAMES ###

func start_minigame_phase():
	#TODO pause player controller
	
	minigames_window.position.x = 400
	minigames_window.position.y = 160
	minigames_window.show()
	
	in_minigame_phase = true
	#timer_label.show()
	timer_container.show()
	
	timer.start(minigames_timer)
	
	for n in task_container.get_children():
		if(n.name != "MarginContainer"):
			var task = n.task_data
			print(task)
			tasks_list.append(task)
	
	next_minigame()

func finish_minigame_phase():	
	timer.stop()
	
	for task in tasks_list:
		if not task.completed:
			on_minigame_not_completed(task)
	
	update_displays() #TBD maybe do a special sequence to recount the incompleted tasks
	
	in_minigame_phase = false
	timer_label.hide()
	
	minigames_window.hide()
	
	end_day()

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
	day_incompleted_tasks += 1
	
	progress_to_no += 1
	if(progress_to_no == no_threshold):
		no_counter += 1
		day_won_nos += 1
		progress_to_no  = 0
	
	likeability_percentage =- likeability_loss
	tasks_list[current_task_index].completed = false

func on_minigame_completed() -> void:
	day_completed_tasks += 1
	
	likeability_percentage += likeability_gain
	tasks_list[current_task_index].completed = true
	
	update_displays()
	
	#TODO check this bc its doing weird stuff
	if is_instance_valid(current_minigame):
		current_minigame.queue_free()
		current_minigame = null
	
	current_task_index += 1
	next_minigame()

func update_displays() -> void:	
	likeability_label.text = "Likeability: " + str(likeability_percentage) + "%"
	no_label.text = "No's: " + str(no_counter)


### TASKS ###

func create_task(task_data : TaskResource):
	print(task_data.title)
	var task = ticket_scene.instantiate() as TaskTicket
	print(task)
	
	task_container.add_child(task)
	task.init_data(task_data)
	


### SIGNALS ###

func _on_timer_timeout() -> void:
	finish_minigame_phase()

func _on_next_day_button_pressed() -> void:
	start_day()



func _on_npc_interacted(npc: NPC) -> void:
	print("start_interaction")

	print(npc.npc_data.to_string() + "\n")
	if npc.npc_data and not npc.npc_data.dialogue.is_empty():
		print(npc.npc_data.to_string() + "\n")
		_dialogue_box.start_dialogue(npc.npc_data.dialogue, npc)
		npc._interaction_prompt.visible = false
		npc._has_talked = true


func _on_dialogue_finished() -> void:
	pass
