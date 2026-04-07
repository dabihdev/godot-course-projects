extends Area2D

@onready var dialog_box: ColorRect = $DialogBox
@onready var label: Label = $DialogBox/Label

# text to be displayed in the label
@export_multiline var message: String = ""

# when player reaches the goddess statue, a dialog box
# is displayed, and a dialog is run
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		dialog_box.visible = true
		label.text = message
