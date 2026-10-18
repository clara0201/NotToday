extends MarginContainer
class_name TaskTicket

@onready var textlabel = $MarginContainer/RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func init_data(task_data = TaskResource):
	textlabel.text = task_data.title + "\n" + "Giver: " + task_data.giver
