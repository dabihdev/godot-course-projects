extends StaticBody2D
@onready var animation_player: AnimationPlayer = $Balloon/AnimationPlayer
@onready var area_2d: Area2D = $Area2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	animation_player.play("exit")
	area_2d.queue_free()
