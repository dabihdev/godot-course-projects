extends CharacterBody2D

@export var speed = 1000

var dir: float         
var spawn_pos: Vector2 # (10.0, 5.0)
var spawn_rot: float   # 0.45

# setup position and rotation
func _ready():
	global_position = spawn_pos
	global_rotation = spawn_rot
	
func _physics_process(delta: float) -> void:
	# determine velocity
	velocity = Vector2.UP.rotated(dir) * speed
	move_and_slide()
