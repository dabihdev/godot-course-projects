extends Node2D

# dichiariamo una nuova proprietà/variabile
# usando var nome_variabile = valore
# @export ci permette di aggiungere
# questa nuova variabile alla lista
# delle proprietà dell'oggetto, sulla destra
@export var speed = 100.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# movimento = posizione che cambia
	# nuova posizione = vecchia posizione + freccia
	position.x += speed*delta
	position.y += speed*delta
	
	# Esercizio: provare diverse combinazioni per vedere
	# come cambia lo spostamento
