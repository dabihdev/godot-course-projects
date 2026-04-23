extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

enum States {
	IDLE,
	RUN,
	JUMP,
	FALL,
	CROUCH,
	CROUCH_WALK
}

var current_state = States.IDLE : set = set_state
var facing_direction = "right"

@onready var animation_player: AnimationPlayer = $AnimationPlayer


# MAIN LOOP
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		if direction > 0:
			facing_direction = "right"
		else:
			facing_direction = "left"
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()

func get_input():
	pass # linka gli input agli stati

func set_state(new_state):
	# Update the value (necessary when using a setter)
	current_state = new_state
	
	var state_name = ""
	
	match current_state:
		States.IDLE:
			state_name = "idle"
		States.RUN:
			state_name = "run"
		States.JUMP:
			state_name = "jump"
		States.FALL:
			state_name = "fall"
		States.CROUCH:
			state_name = "crouch"
		States.CROUCH_WALK:
			state_name = "crouch_walk"

	# Combine the state name with the direction
	var animation_to_play = state_name + "_" + facing_direction
	
	# Play the animation if it exists in the AnimationPlayer
	if animation_player.has_animation(animation_to_play):
		animation_player.play(animation_to_play)
