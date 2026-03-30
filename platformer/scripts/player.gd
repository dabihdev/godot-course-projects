extends CharacterBody2D

# constants
const SPEED = 300.0
const JUMP_VELOCITY = -900.0

# nodes we need to interact with
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

# original and crouched shape and position of collision shape 2d
@onready var original_shape_size = Vector2(31.0, 60.0)
@onready var original_shape_position = Vector2(0.0, 17.0)
var crouched_shape_size = Vector2(31.0, 47.0) # found this one by just looking at the inspector
var crouched_shape_position = Vector2(0.0, 23.5) # found this one by just looking at the inspector

# other variables
var gravity = 2000 * Vector2.DOWN
var crouched: bool = false


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()
		
	if Input.is_action_pressed("crouch") and is_on_floor():
		crouch()
	else:
		stand()

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	move_horizontally(direction)
	
	# finally call move_and_slide, then begin new loop
	move_and_slide()


# MOVEMENTS =================================================================
func jump():
	velocity.y = JUMP_VELOCITY

func crouch():
	# crouch if not
	if not crouched:
		crouched = true
		# reshape and reposition collision shape
		collision_shape_2d.shape.size = crouched_shape_size
		collision_shape_2d.position = crouched_shape_position
		
		# log
		print_collision_shape_parameters()
	
	# play animation
	animated_sprite_2d.play("crouching")
	
	
func stand():
	# stand if crouched
	if crouched:
		crouched = false
		
		# reset to original shape/position
		collision_shape_2d.shape.size = original_shape_size
		collision_shape_2d.position = original_shape_position
		
		# log
		print_collision_shape_parameters()
	
	
func move_horizontally(direction):
	if direction: # moving
		velocity.x = direction * SPEED
		if direction < 0:
			animated_sprite_2d.flip_h = true
		else:
			animated_sprite_2d.flip_h = false
		animated_sprite_2d.play("running")
	else: # decelerates until idle
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if not crouched:
			animated_sprite_2d.play("idle")


# LOG FUNCTIONS ==============================================================
func print_collision_shape_parameters():
	# print current size and position
	print("Size:", collision_shape_2d.shape.size)
	print("Position:", collision_shape_2d.position)
