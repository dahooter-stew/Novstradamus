extends Path2D

@export var guard_speed: float

@onready var guard_path: GuardPathFollow = $GuardPath
@onready var guard: Guard = $GuardPath/Guard
@onready var remote_transform_path: GuardPathFollow = $RemoteTransformPath

func _physics_process(delta: float) -> void:
	if guard and not guard.state == guard.State.INACTIVE:
		guard_path.move_through_path(guard_speed, delta)
		remote_transform_path.move_through_path(guard_speed, delta)
	
	#print(remote_transform_path.rotation)
