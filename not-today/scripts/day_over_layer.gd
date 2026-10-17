extends CanvasLayer

@onready var DO_completed_tasks = $PanelContainer/VBoxContainer/CompletedTasksLabel
@onready var DO_likeability = $PanelContainer/VBoxContainer/LikeabilityLabel
@onready var DO_incompleted_tasks = $PanelContainer/VBoxContainer/IncompletedTasksLabel
@onready var DO_no = $PanelContainer/VBoxContainer/NoLabel

var DO_completed_tasks_template = "You've completed: %s tasks"
var DO_incompleted_tasks_template = "You've let people down: %s times"
var DO_likeability_template = "So they like you aprox... %s %%"
var DO_no_template = "So you've won... %s No's!"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func initialize(completed_t : int, uncompleted_t : int, likeability : int, no : int):
	DO_completed_tasks.text = DO_completed_tasks_template % completed_t
	DO_incompleted_tasks.text = DO_incompleted_tasks_template % uncompleted_t
	DO_likeability.text = DO_likeability_template % likeability
	DO_no.text = DO_no_template % no
