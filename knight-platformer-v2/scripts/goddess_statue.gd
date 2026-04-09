extends Area2D

@onready var label: Label = $Label

# text to be displayed in the label
@export_multiline var message: String = ""

# when player reaches the goddess statue, a dialog box
# is displayed, and a dialog is run
func _on_body_entered(body: Node2D) -> void:
	label.text = message

# when player exits, reset the label to empty
func _on_body_exited(body: Node2D) -> void:
	label.text = ""
