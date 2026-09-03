extends Area2D

@onready var marker: Marker2D = $Marker2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	collision_shape.set_deferred("disabled", true)
	if body is Player:
		var guard_instance = preload("res://scenes/guard.tscn").instantiate()
		guard_instance.global_position = marker.global_position
		guard_instance.sight_rotation = -180
		#guard_instance.velocity.x = -100
		get_parent().add_child(guard_instance)
