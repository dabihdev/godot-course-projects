extends Area2D

@onready var dialog_box: ColorRect = $DialogBox
@onready var message: Label = $DialogBox/Label

# quando il giocatore entra nell'area intorno alla statua
# fai partire il dialogo
func _on_body_entered(body: Node2D) -> void:
	dialog_box.visible = true
	message.text = "Benvenuto in questa terra,\nstraniero"
