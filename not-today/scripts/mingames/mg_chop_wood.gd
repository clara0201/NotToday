extends Minigame


@onready var axe = $Axe
@onready var background = $Background
@onready var left_limit = $LeftLimit
@onready var right_limit = $RightLimit
@onready var wood_area = $WoodTrunk/Area2D
@onready var wood_area_bottom = $WoodTrunk/Bottom
@onready var bottom_area = $Bottom
@onready var wood_chopped = $WoodChopped
@onready var wood = $WoodTrunk

const SPEED_MOVE = 800
const SPEED_DROP = 1000

var direction = 1.0
var moving = true
var dropping = false
var axe_init_pos : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	axe_init_pos = axe.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(moving):
		axe.position.x += SPEED_MOVE * direction * delta
		
		if axe.position.x >= right_limit.position.x:
			direction = -1.0
		elif axe.position.x <= left_limit.position.x:
			direction = 1.0
	
	if(dropping):
		axe.position.y += SPEED_DROP * 1.0 * delta


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			moving = false
			dropping = true

func start_minigame() -> void:
	#TODO
	pass


func _on_axe_area_2d_area_entered(area: Area2D) -> void:
	if(area == wood_area):
		wood.visible = false
		wood_chopped.visible = true
	
	elif(area == wood_area_bottom):
		moving = false
		dropping = false
		await get_tree().create_timer(0.5).timeout
		finish_minigame()
	
	elif(area == bottom_area):
		dropping = false
		axe.position = axe_init_pos
		await get_tree().create_timer(0.5).timeout
		moving = true
