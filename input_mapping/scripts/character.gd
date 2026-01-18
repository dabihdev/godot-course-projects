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
	# Ora diciamo al programma di cambiare direzione
	# in base all'input ricevuto
	# abbiamo 4 casi
	if Input.is_action_pressed("move_up"):
		position.y -= speed*delta
		rotation += 1*delta
	elif Input.is_action_pressed("move_down"):
		position.y += speed*delta
		rotation -= 1*delta
	elif Input.is_action_pressed("move_left"):
		position.x -= speed*delta
		scale.x +=1*delta
	elif Input.is_action_pressed("move_right"):
		position.x += speed*delta
		scale.x -=1*delta
	elif Input.is_action_pressed("skew_sprite"):
		skew += 1*delta
	# Esercizio 1: modifica altre proprietà in base all'input
	# Esercizio 2: mappa un nuovo input (per sempio il tasto 'A')
	# e gestiscilo modificando lo Skew o un altro parametro
