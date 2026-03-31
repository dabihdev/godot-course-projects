extends CharacterBody2D

# preloaded objects
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


# player speeds
@export var speed = 300.0
@export var jump_velocity = -900.0

# player's state
enum States {
	IDLE,
	RUN,
	JUMP,
	FALL,
	CROUCH,
	CROUCH_MOVE
}
var current_state = States.IDLE

# world gravity
var gravity = 2500.0 *Vector2(0, 1)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		# change facing direction based on direction
		if direction < 0: sprite.flip_h = true
		else: sprite.flip_h = false
		
		# update horizontal velocity
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	# update state
	update_state()
	
	# play animation based on current state
	play_animation()

	move_and_slide()

func update_state():
	# guard clause: fall if not on floor
	if not is_on_floor():
		current_state = States.FALL
		return
	
	# handle inputs
	if Input.is_action_pressed("crouch"):
		current_state = States.CROUCH
	elif Input.is_action_just_pressed("jump"):
		current_state = States.JUMP
	elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		current_state = States.RUN
	else:
		current_state = States.IDLE

func play_animation():
	match current_state:
		States.IDLE:
			sprite.play("idle")
		States.RUN:
			sprite.play("run")
		States.JUMP:
			sprite.play("jump")
		States.FALL:
			sprite.play("fall")
		States.CROUCH:
			sprite.play("crouch")
			
