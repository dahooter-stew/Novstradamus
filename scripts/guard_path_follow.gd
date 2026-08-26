class_name GuardPathFollow extends PathFollow2D

@export var pathing_guard: Node2D
@export var guard_speed: float

func _ready() -> void:
	print(pathing_guard.get_children())

func _physics_process(delta: float) -> void:
	progress_ratio += (guard_speed / 100) * delta
