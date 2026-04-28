extends CharacterBody2D


@export var max_speed = 500.0
@export var jump_speed = -500.0
var crouch_speed = max_speed/3
var current_speed = max_speed

enum States {
	IDLE,
	RUN,
	JUMP,
	FALL,
	CROUCH,
	CROUCH_WALK,
	HIT,
	DEAD
}

var current_state = States.IDLE : set = set_state
var facing_direction = "right"

@onready var animation_player: AnimationPlayer = $AnimationPlayer


# MAIN LOOP
func _physics_process(delta: float) -> void:
	# IMMEDIATE DEATH LOCK
	# If we are dead, we skip all input and state logic entirely.
	if current_state == States.DEAD:
		if not is_on_floor():
			velocity += get_gravity() * delta # Still allow the corpse to fall
		move_and_slide()
		return # EXIT THE FUNCTION HERE
	
	# HIT LOCK
	if current_state == States.HIT:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		if not is_on_floor():
			velocity += get_gravity() * delta
		move_and_slide()
		return # EXIT THE FUNCTION HERE

	# GRAVITY (Only happens if alive)
	if not is_on_floor():
		velocity += get_gravity() * delta
		# Only change to FALL if we aren't doing something else like JUMPING
		if velocity.y > 0:
			current_state = States.FALL
			
	# FLOOR LOGIC (Input-based state changes)
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			current_state = States.JUMP
		elif Input.is_action_pressed("crouch"):
			current_state = States.CROUCH
		elif Input.is_action_just_pressed("attack"):
			current_state = States.HIT
		elif Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left"):
			current_state = States.RUN
		else:
			current_state = States.IDLE

	# HORIZONTAL MOVEMENT LOGIC
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		if current_state == States.CROUCH:
			current_state = States.CROUCH_WALK
		
		velocity.x = direction * current_speed
		
		# Flip direction
		if direction > 0: facing_direction = "right"
		else: facing_direction = "left"
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
	
	move_and_slide()

# SETTER FUNCTION: fired every time the current state changes
# Handles logic and animation changes whenever the state changes
func set_state(new_state):
	# Update the value (necessary when using a setter)
	var previous_state = current_state
	current_state = new_state
	
	# Check if state has a different value
	# if not stop it here to avoid useless repetition
	if previous_state == current_state:
		return
	
	# Reset speed to maximum
	current_speed = max_speed
	
	var state_name = ""
	
	match current_state:
		States.IDLE:
			state_name = "idle"
		States.RUN:
			state_name = "run"
		States.JUMP:
			state_name = "jump"
			velocity.y = jump_speed
		States.FALL:
			state_name = "fall"
		States.CROUCH:
			state_name = "crouch"
			current_speed = crouch_speed
		States.CROUCH_WALK:
			state_name = "crouch_walk"
			current_speed = crouch_speed
		States.HIT:
			state_name = "hit"
			velocity.x = 0
			current_speed = 0
		States.DEAD:
			state_name = "die"
			collision_layer = 0
			collision_mask = 0
			velocity.x = 0
			current_speed = 0

	# Combine the state name with the direction
	var animation_to_play = state_name + "_" + facing_direction
	
	# Play the animation if it exists in the AnimationPlayer
	if animation_player.has_animation(animation_to_play):
		animation_player.play(animation_to_play)
		
func dies():
	# set state
	current_state = States.DEAD
	
	
	
