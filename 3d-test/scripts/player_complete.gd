extends CharacterBody3D

# Movement variables
@export var SPEED: float = 5.0
@export var JUMP_VELOCITY: float = 4.5
@export var MOUSE_SENSITIVITY: float = 0.003

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

# Node references for camera rotation
@onready var twist_pivot: Node3D = $TwistPivot
@onready var pitch_pivot: Node3D = $TwistPivot/PitchPivot

func _ready():
	# Captures the mouse cursor so it stays locked inside the game window
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	# 1. Add the gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# 2. Handle Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# 3. Get input direction and handle movement
	# "ui_left", "ui_right", etc. map to arrow keys by default. 
	# You can change these to WASD in Project Settings -> Input Map.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Rotate the movement direction based on which way the camera/twist_pivot is facing
	var direction := (twist_pivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	# 4. Move the player using built-in physics engine
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	# Handles mouse movement for camera rotation
	if event is InputEventMouseMotion:
		# Twist the whole body/horizontal pivot
		twist_pivot.rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		# Pitch the camera up and down
		pitch_pivot.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		
		# Clamp the vertical pitch so you can't look completely upside down
		pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, deg_to_rad(-60), deg_to_rad(60))
		
	# Press ESC to get your mouse cursor back
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
