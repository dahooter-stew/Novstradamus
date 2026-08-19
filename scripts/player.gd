extends CharacterBody2D

func _physics_process(delta: float) -> void:
	var dir = Input.get_vector("left", "right", "up", "down")
	
	position += dir * 100 * delta
