extends Area2D

@onready var marker: Marker2D = $Marker2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var guard_instance

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body is Player:
		collision_shape.set_deferred("disabled", true)
		guard_instance = load("res://scenes/guard.tscn").instantiate()
		guard_instance.global_position = marker.global_position
		guard_instance.sight_rotation = 180
		guard_instance.velocity.x = -150
		get_parent().add_child(guard_instance)
		await get_tree().create_timer(1.5).timeout
		guard_instance.velocity.x = 0
		guard_instance.sight_rotation = 0

func _physics_process(delta: float) -> void:
	if guard_instance and guard_instance.state == guard_instance.State.ACTIVE:
		guard_instance.move_and_slide()
