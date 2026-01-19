extends CharacterBody2D # Change this from Node2D

@export var speed = 300.0 # Physics movement usually requires higher speed values

func _physics_process(delta: float) -> void:
	# 1. Reset velocity every frame
	var direction = Vector2.ZERO

	# 2. Capture input to create a direction vector
	if Input.is_action_pressed("move_up"):
		direction = Vector2.UP
	elif Input.is_action_pressed("move_down"):
		direction = Vector2.DOWN
	elif Input.is_action_pressed("move_left"):
		direction = Vector2.LEFT
	elif Input.is_action_pressed("move_right"):
		direction = Vector2.RIGHT

	# 3. Apply velocity
	# adding .normalized() prevents diagonal movement from being
	# faster
	velocity = direction * speed

	# 4. Use move_and_slide() 
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
