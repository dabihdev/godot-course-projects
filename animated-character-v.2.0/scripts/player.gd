extends CharacterBody2D

# Speeds
@export var max_speed = 500.0
@export var jump_speed = -500.0
var crouch_speed = max_speed/3
var current_speed = max_speed

# HP
@export var max_hp = 100
var current_hp = max_hp

# States
enum States {
	IDLE,
	RUN,
	JUMP,
	FALL,
	CROUCH,
	CROUCH_WALK,
	ATTACK,
	HIT,
	DEAD
}
var current_state = States.IDLE : set = set_state
var facing_direction = "right"

# Accessed Nodes
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hit_cool_down: Timer = $HitCoolDown
@onready var attack_cool_down: Timer = $AttackCoolDown

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
		
	# ATTACK LOCK
	if current_state == States.ATTACK:
		return # STOP FURTHER PHYSICS FROM HAPPENING

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
			current_state = States.ATTACK
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
		
		# Track if direction changed
		var old_direction = facing_direction
		if direction > 0 : facing_direction = "right"
		else: facing_direction = "left"
		
		# If direction changed while in the same state, manually update animation
		if old_direction != facing_direction:
			update_animation()
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		
	move_and_slide()

# SETTER FUNCTION: fired every time the current state changes
# Handles logic and animation changes whenever the state changes
func set_state(new_state):
	if current_state == new_state:
		return
		
	current_state = new_state
	
	# Reset speed to maximum (default)
	current_speed = max_speed
	
	# Handle specific physics changes on state entry
	match current_state:
		States.JUMP:
			velocity.y = jump_speed
		States.CROUCH, States.CROUCH_WALK:
			current_speed = crouch_speed
		States.ATTACK:
			velocity.x = 0
			attack_cool_down.start() # start timer
		States.HIT, States.DEAD:
			velocity.x = 0
			
	# Now that physics are set, update the visuals
	update_animation()

func update_animation():
	var state_name = ""
	
	match current_state:
		States.IDLE: state_name = "idle"
		States.RUN: state_name = "run"
		States.JUMP: state_name = "jump"
		States.FALL: state_name = "fall"
		States.CROUCH: state_name = "crouch"
		States.CROUCH_WALK: state_name = "crouch_walk"
		States.ATTACK: state_name = "attack"
		States.HIT: state_name = "hit"
		States.DEAD: state_name = "die"

	var animation_to_play = state_name + "_" + facing_direction
	
	
	if animation_player.has_animation(animation_to_play):		
		# play the new animation
		animation_player.play(animation_to_play)

func take_damage(hp_amount: int):
	print("HERE")
	# if HP goes to 0, die
	if hp_amount >= current_hp:
		current_hp = 0
		die()
		return
	
	# else take the hit
	current_hp -= hp_amount
	hit_cool_down.start()
	current_state = States.HIT
	
func die():
	current_state = States.DEAD
	
func _on_hit_cool_down_timeout() -> void:
	current_state = States.IDLE

func _on_attack_cool_down_timeout() -> void:
	current_state = States.IDLE
