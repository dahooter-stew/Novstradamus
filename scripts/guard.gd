extends CharacterBody2D
class_name Guard

enum State {
	ACTIVE,
	INACTIVE
}

@onready var takedown_prompt: Control = $TakedownPrompt
@onready var body_collision_shape: CollisionShape2D = $BodyCollisionShape
@onready var player_detection_area: Area2D = $PlayerDetectionArea
@onready var state: State = State.ACTIVE

func _ready() -> void:
	player_detection_area.body_entered.connect(on_player_detected)

func inactive():
	if state == State.INACTIVE:
		return
	state = State.INACTIVE
	
	body_collision_shape.disabled = true

func active():
	if state == State.ACTIVE:
		return
	state = State.ACTIVE
	
	body_collision_shape.disabled = false

func on_player_detected(player):
	if player is Player:
		player.detection_manager.guard_attacking = self
		player.toggle_qte.emit()
