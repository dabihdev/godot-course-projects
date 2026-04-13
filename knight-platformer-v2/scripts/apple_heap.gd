extends Area2D

# Children Nodes
@onready var sprite: Sprite2D = $Sprite2D
@onready var hint_label: Label = $HintLabel
@onready var hp_label: Label = $HPLabel

# Player's Body Initialization
var entered_body : Node2D

# AppleHeap states
enum States {
	FULL,
	HALF
}
var current_state = States.FULL # current state of AppleHeap

# small heap texture crop
# get smaller version of apple heap from tileset
# position  (x, y) , size (widht, height)
const SMALL_HEAP_REGION = Rect2(326.0, 21.0, 19.0, 11.0)

# amount of HP gained
@export var hp_amount: int = 10

# main function
func _physics_process(delta: float):
	# if player not near enough, stop it here
	if not entered_body:
		return
		
	# if player is near enough, change
	# sprite texture according to the
	# AppleHeap state. 'Eat' action is triggered
	# by a specific key
	if Input.is_action_just_pressed("action")	:
		# update entered body's health
		entered_body.heal(hp_amount)
		
		# Update Apple Heap State
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
	entered_body = body

# ...when exiting the apples area
func _on_body_exited(body: Node2D) -> void:
	hint_label.visible = false
	entered_body = body
