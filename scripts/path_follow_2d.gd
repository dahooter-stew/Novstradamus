extends PathFollow2D

@export var pathing_guard: Node2D

func _process(delta: float) -> void:
	# Increase progress by speed multiplied by delta
	progress += 25 * delta
