extends CharacterBody2D # Change this from Node2D

@export var speed = 300.0 # Physics movement usually requires higher speed values
var direction = Vector2.ZERO
var rot_direction = 0.0

func _physics_process(delta: float) -> void:
	# 1. Capture input to create a direction vector
	direction = Input.get_vector("move_left","move_right","move_up","move_down")
	rot_direction = Input.get_axis("rotate_left","rotate_right")
	# 2. Update velocity
	# adding .normalized() prevents diagonal movement from being
	# faster
	velocity = direction * speed
	

	# 3. Use move_and_slide() 
	# This function automatically uses 'velocity' and 'delta'
	move_and_slide()

	# Rotation can still be handled manually as it doesn't usually 
	# affect the 'sliding' collision in 2D top-down games
	if Input.is_action_pressed("rotate_left"):
		rotation -= 1 * delta
	elif Input.is_action_pressed("rotate_right"):
		rotation += 1 * delta

# Exercise 1: add more rocks
# Execise 2: see what happens if you change rock layer
# (no collision)
