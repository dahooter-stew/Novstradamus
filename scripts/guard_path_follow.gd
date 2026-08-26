class_name GuardPathFollow extends PathFollow2D

@export var pathing_guard: Node2D

func move_through_path(guard_speed, delta):
	progress_ratio += (guard_speed / 100) * delta
