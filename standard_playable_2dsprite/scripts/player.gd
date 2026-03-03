extends Node2D

@export var speed = 300.0 # set up speed

var direction = Vector2.ZERO # initialize direction to zero

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Get direction vector from input
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction != Vector2.ZERO:
		print(direction)
	# Update player position accordingly
	position += direction * speed * delta
