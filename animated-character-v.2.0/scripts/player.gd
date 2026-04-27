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
	HIT
}

var current_state = States.IDLE : set = set_state
var facing_direction = "right"

@onready var animation_player: AnimationPlayer = $AnimationPlayer


# MAIN LOOP
func _physics_process(delta: float) -> void:
	# When not on floor.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if velocity.y > 0:
			current_state = States.FALL

	# When on floor (actions)
	else:
		# --> IDLE state (set as default)
		current_state = States.IDLE
		
		# --> JUMP state
		if Input.is_action_just_pressed("jump"):
			current_state = States.JUMP
		
		# --> CROUCH state
		elif Input.is_action_pressed("crouch"):
			current_state = States.CROUCH
			
		# --> HIT state
		elif Input.is_action_just_pressed("attack"):
			current_state = States.HIT
		
		# --> RUN state
		elif Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left"):
			current_state = States.RUN

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		# if moving while crouched, go to crouch walk
		if current_state == States.CROUCH:
			current_state = States.CROUCH_WALK
		
		# update horizontal velocity
		velocity.x = direction * current_speed
		
		# handle character facing direction
		if direction > 0:
			facing_direction = "right"
		else:
			facing_direction = "left"
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
	
	move_and_slide()


func set_state(new_state):
	# Update the value (necessary when using a setter)
	current_state = new_state
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
			current_speed = 0

	# Combine the state name with the direction
	var animation_to_play = state_name + "_" + facing_direction
	
	# Play the animation if it exists in the AnimationPlayer
	if animation_player.has_animation(animation_to_play):
		animation_player.play(animation_to_play)
