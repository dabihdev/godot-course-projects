extends ProgressBar
@onready var player = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update()
	player.player_hurt.connect(update)

# update the bar value
func update():
	value = player.currentHealth * 100 / player.maxHealth
