class_name GuardPathFollow extends PathFollow2D

@export var pathing_guard: Node2D
@export var guard_speed: float

func move_through_path(delta):
	progress_ratio += (guard_speed / 100) * delta
