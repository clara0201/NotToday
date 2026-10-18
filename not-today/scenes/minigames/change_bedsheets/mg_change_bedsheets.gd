extends Minigame
class_name ChangeBedsheetsMG

@onready var old_bedsheet = $OldBedsheetsSprite2D
@onready var old_bedsheet_top = $OldBedsheetsSprite2D/TopArea2D
@onready var goal_bottom = $GoalBottomArea2D
@onready var laundry_basket = $LaundryBasket

@onready var new_bedsheet = $NewBedsheetsSprite2D
@onready var new_bedsheet_top = $NewBedsheetsSprite2D/NewTopArea2D
@onready var goal_top = $GoalTopArea2D

var is_dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO

const SPEED = 5.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_new_bedsheets():
	new_bedsheet.visible = true

func _on_bedsheet_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_dragging = true
			drag_offset.y = old_bedsheet.position.y - event.position.y
			$AudioStreamPlayer.play()
		else:
			is_dragging = false

	# Move the object when the mouse moves while dragging
	elif event is InputEventMouseMotion and is_dragging:
		old_bedsheet.position.y = event.position.y + drag_offset.y

func _on_top_area_2d_area_entered(area: Area2D) -> void:
	if(area == goal_bottom):
		old_bedsheet.visible = false
		is_dragging = false
		await get_tree().create_timer(0.5).timeout
		get_new_bedsheets()

func _on_new_bedsheet_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	# Check if the left mouse button is pressed or released
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_dragging = true
			drag_offset.y = new_bedsheet.position.y - event.position.y
			$AudioStreamPlayer.play()
		else:
			is_dragging = false

	# Move the object when the mouse moves while dragging
	elif event is InputEventMouseMotion and is_dragging:
		new_bedsheet.position.y = event.position.y + drag_offset.y

func _on_new_top_area_2d_area_entered(area: Area2D) -> void:
	print(area.name)
	if(area == goal_top):
		finish_minigame()
