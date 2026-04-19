extends CharacterBody2D

# stats
@export var max_hp: int = 20
var current_hp: int
@export var attack: int = 10
@export var speed = 300.0

# target
var target: CharacterBody2D
var is_attacking = false
# states
enum States {
	IDLE,
	RUN,
	ATTACK,
	DEAD
}
var current_state = States.IDLE

# flags
var is_stun: bool = false


func _ready():
	current_hp = max_hp # set initial hp value

# MAIN LOOP
func _physics_process(delta: float) -> void:
	detect_player() # raycast detects player (or not)
	handle_movement(delta) # move towards player if detected
	play_animation() # play all animations based on the current state
	move_and_slide()

	
func detect_player():
	if current_state == States.DEAD:
		return
						
	if $RayCast2D.is_colliding():
		current_state = States.ATTACK
		target = $RayCast2D.get_collider()
		is_attacking=true
		print("Target detected")


func handle_movement(delta):
	# vertical
	if current_state!=States.DEAD and not is_on_floor():
		velocity += Globals.gravity * delta
		current_state = States.IDLE
		
	# horizontal
	if current_state==States.RUN:
		global_position = global_position.move_toward(target.global_position, speed*delta)
	else: # smooth stopping
		velocity.x = move_toward(velocity.x, 0, speed)
	
	if is_attacking:
		$Sword/AnimationPlayer.play("attack")
		await $Sword/AnimationPlayer.animation_finished
		is_attacking=false
		print("attacking")
	
func play_animation():
	
	# match main states to their animations		
	match current_state:
		States.IDLE:
			$AnimatedSprite2D.play("idle")
		States.RUN:
			$AnimatedSprite2D.play("run")	
	
func take_damage(damage_amount: int):
	# update player's HP
	var total_hp = current_hp - damage_amount # temporary total
	if total_hp <= 0:
		dies()
	else:
		current_hp = total_hp
		is_stun = true

func dies():
	# update state
	current_state = States.DEAD
	# delete hit and hurtbox
	$Sword.queue_free()
	# play death animation
	$AnimatedSprite2D.play("dead")
	# remove collision shapes
	$CollisionShape2D.queue_free()
	$RayCast2D.queue_free()
