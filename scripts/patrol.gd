extends Path2D

@export var guard_speed: float

@onready var guard_path: GuardPathFollow = $GuardPath
@onready var guard: Guard = $GuardPath/Guard
@onready var remote_transform_path: GuardPathFollow = $RemoteTransformPath

func _physics_process(delta: float) -> void:
	if guard and guard.state == guard.State.ACTIVE:
			guard_path.move_through_path(guard_speed, delta)
			remote_transform_path.move_through_path(guard_speed, delta)

	#print(remote_transform_path.get_child(0))
