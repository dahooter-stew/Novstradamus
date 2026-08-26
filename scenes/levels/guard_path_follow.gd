class_name GuardPathFollow extends PathFollow2D

@export var pathing_guard: Guard
@export var guard_speed: float

func _physics_process(delta: float) -> void:
	progress_ratio += (guard_speed / 100) * delta
