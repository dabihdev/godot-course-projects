extends Node2D

var distanza = 0 # definisco per la prima volta una variabile
var direzione = 1 # 1 verso destra, -1 verso sinistra
@export var distanza_massima = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	
	# quandso raggiunge la distanza massima, si azzera e cambia direzione
	if distanza >= distanza_massima: # pixel
		direzione = -direzione # la direzione cambia
		distanza = 0
	
	# muovo il personaggio
	position.x += 2 * direzione
	
	# incremento la distanza
	distanza += 2
