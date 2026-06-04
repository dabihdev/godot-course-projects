extends CharacterBody2D

var bullet = preload("res://bullet.tscn") # our bullet scene

# main cannon logic and movement
func _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position())
	if Input.is_action_pressed("ui_accept"):
		fire()
		
func fire():
	var projectile = bullet.instantiate() # instantiate bullet scene
	projectile.dir = rotation
	projectile.spawn_pos = position # set projectile's position and rotation
	projectile.spawn_rot = global_rotation
	projectile.z_index = z_index - 1
	get_parent().add_child.call_deferred(projectile)# add bullet instance to the scene tree
	
