extends Area2D

@export var damage = 50
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var cool_down: Timer = $CoolDown

func _on_body_entered(body: Node2D) -> void:
	collision_shape_2d.set_deferred("disabled", true)
	cool_down.start()
	body.take_damage(damage)
	
func _on_cool_down_timeout() -> void:
	collision_shape_2d.set_deferred("disabled", false)
