extends CharacterBody2D

# preloaded objects
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

# player speeds
@export var max_speed = 500.0
@export var jump_speed = -1000.0
@export var crouch_speed = 100.0
var current_speed = max_speed

# player's state
enum States {
	IDLE,
	RUN,
	JUMP,
	FALL,
	CROUCH,
	CROUCH_WALK
}
var current_state = States.IDLE

# Player's stats
@export var max_hp    : int = 100
@export var current_hp: int = 100
@export var attack    : int = 10

# HUD
@onready var HUD: Control = $"../HUD/UI"

# MAIN LOOP
func _physics_process(delta: float) -> void:
	# update state
	update_state()
	
	# handle movement
	handle_movement(delta)
	
	# play animation based on current state
	play_animation()

	move_and_slide()

func handle_movement(delta):	
	# 1. gravity.
	if current_state==States.FALL:
		velocity += Globals.gravity * delta

	# 3. jump
	if current_state==States.JUMP:
		velocity.y = jump_speed

	# 4. horizontal movement
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		# change facing direction based on direction
		if direction < 0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
		# update horizontal velocity
		velocity.x = direction * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)

func update_state():
	# guard clause: fall if not on floor
	if not is_on_floor():
		current_state = States.FALL
		return
	
	# handle inputs
	if Input.is_action_pressed("crouch"):
		if Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left"):
			current_state = States.CROUCH_WALK
		else:
			current_state = States.CROUCH
	elif Input.is_action_just_pressed("jump"):
		current_state = States.JUMP
	elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		current_state = States.RUN
	else:
		current_state = States.IDLE

func play_animation():	
	current_speed = max_speed # reset speed to maximum
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
			current_speed = crouch_speed # slower when crouched
			sprite.play("crouch")
		States.CROUCH_WALK:
			current_speed = crouch_speed # slower when crouched
			sprite.play("crouch_walk")
			
		
func heal(hp_amount: int):
	# update player's HP
	var total_hp = current_hp + hp_amount # temporary total
	if total_hp > max_hp: # nothing happens if HP already full
		current_hp = max_hp
	else:
		current_hp = total_hp # update HP if not full yet
	
	# update HUD
	HUD.update_label()
	
func take_damage(damage_amount: int):		
	# update player's HP
	var total_hp = current_hp - damage_amount # temporary total
	if total_hp < 0:
		current_hp = 0
	else:
		current_hp = total_hp
	
	# update HUD
	HUD.update_label()
