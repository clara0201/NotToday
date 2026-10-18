extends CharacterBody2D

@onready var playerSprite = $"../Player/Player Sprite"
@onready var animatedsprite = $"AnimatedSprite2D"

const SPEED = 500.0

var facing = "right"

func _physics_process(delta: float) -> void:
	# Add the gravity.
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("left", "right","up","down")
	

	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	if Input.is_action_pressed("right"):
		animatedsprite.play("runL")
		facing = "right"
		animatedsprite.flip_h = true

	if Input.is_action_pressed("up"):
		animatedsprite.play("runL")
		
	if Input.is_action_pressed("down"):
		animatedsprite.play("runL")
	
	if Input.is_action_pressed("left"):
		animatedsprite.play("runL")
		facing = "left"
		animatedsprite.flip_h = false
		
	if !Input.is_action_pressed("left") && !Input.is_action_pressed("right") && !Input.is_action_pressed("down") && !Input.is_action_pressed("up"):
		animatedsprite.play("default")
	
	move_and_slide()
