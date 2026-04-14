extends CharacterBody2D

# stats
@export var max_hp: int = 20
var current_hp: int
@export var attack: int = 10

# states
enum States {
	IDLE,
	RUN,
	DEAD
}
var current_state = States.IDLE

func _ready():
	current_hp = max_hp
	
func take_damage(damage_amount: int):
	# update player's HP
	var total_hp = current_hp - damage_amount # temporary total
	if total_hp <= 0:
		dies()
	else:
		current_hp = total_hp
		$AnimatedSprite2D.play("hurt")

func dies():
	$HitBox.queue_free()
	$HurtBox.queue_free()
	$AnimatedSprite2D.play("die")
	$CollisionShape2D.queue_free()
