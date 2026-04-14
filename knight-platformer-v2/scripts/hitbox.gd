class_name HitBox
extends Area2D

# Hit box should be placed as child of character
@onready var character: CharacterBody2D = $".."

func _on_body_entered(body: Node2D) -> void:
	body.take_damage(character.attack) 
