class_name PatrollingGuard extends Node2D

@onready var guard_path: GuardPathFollow = $Path2D/GuardPath
@onready var guard: Guard = $Path2D/GuardPath/Guard
@onready var remote_transform_path: GuardPathFollow = $Path2D/RemoteTransformPath
