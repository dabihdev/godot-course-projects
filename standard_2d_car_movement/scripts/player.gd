extends Node2D

@export var speed = 300.0

var direction = Vector2.ZERO
const rotation_speed = PI * 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# 1) Input
	# get rotation direction from left-right input
	var rotation_direction = Input.get_axis("turn_left", "turn_right")
	# get movement direction from forwards-backwards input
	var movement_direction = Input.get_axis("move_on", "move_back")
	
	# 2) Update
	# rotate character and its movement direction
	rotation += rotation_direction * rotation_speed * delta
	direction = Vector2.DOWN.rotated(rotation)
	
	# finally, update position
	position += movement_direction * direction * speed * delta
