extends Area2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var hint_label: Label = $HintLabel
@onready var hp_label: Label = $HPLabel


# AppleHeap states
enum States {
	FULL,
	HALF
}
var current_state = States.FULL # current state of AppleHeap

# is the player near enough to eat the apples?
var can_eat: bool = false

# small heap texture crop
# get smaller version of apple heap from tileset
# position  (x, y) , size (widht, height)
const SMALL_HEAP_REGION = Rect2(326.0, 21.0, 19.0, 11.0)
	
# main function
func _physics_process(delta: float):
	# if player not near enough, stop it here
	if not can_eat:
		return
	
	# if player is near enough, change
	# sprite texture according to the
	# AppleHeap state. 'Eat' action is triggered
	# by a specific key
	if Input.is_action_just_pressed("action")	:
		# signal HP have been gained
		Signals.gain_hp.emit()
		
		# Perform action based on current state
		match current_state:
			States.FULL:
				sprite.region_rect = SMALL_HEAP_REGION
				sprite.position.y += 8 # change base position
				current_state = States.HALF # reduce the heap
			States.HALF:
				queue_free() # deletes the AppleHeap instance
			

# when entering the apples area...
func _on_body_entered(body: Node2D) -> void:
	hint_label.visible = true
	can_eat = true

# ...when exiting the apples area
func _on_body_exited(body: Node2D) -> void:
	hint_label.visible = false
	can_eat = false
