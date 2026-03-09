extends Area2D

var target: CharacterBody2D = null
@onready var boost_timer: Timer = $BoostTimer


func _on_body_entered(body: CharacterBody2D) -> void:
	if body.name == "Player":
		target = body
		target.current_speed *= 2
		boost_timer.start()

func _on_boost_timer_timeout() -> void:
	target.current_speed = target.speed
