class_name HurtBox
extends Area2D

# Hurt box should be placed as child of character
@onready var character: CharacterBody2D = $".."

#
func _on_body_entered(body: Node2D) -> void:
	character.take_damage(body.attack)
