extends CharacterBody2D
class_name Guard

enum State {
	ACTIVE,
	INACTIVE
}

@export var sight_rotation: float = 0

@onready var takedown_prompt: Control = $TakedownPrompt
@onready var sprite: AnimatedSprite2D = $GuardSprite
@onready var body_collision_shape: CollisionShape2D = $BodyCollisionShape
@onready var player_detection_area: Area2D = $PlayerDetectionArea
@onready var player_detection_collision_shape: CollisionShape2D = $PlayerDetectionArea/PlayerDetectionCollisionShape
@onready var exclamation: Label = $Exclamation
@onready var state: State = State.ACTIVE
#@onready var sight_line_offset: int

func _ready() -> void:
	player_detection_area.body_entered.connect(on_player_detected)
	#sight_line_offset = player_detection_area.position.y
	#print(sight_line_offset)

func _physics_process(delta: float) -> void:
	player_detection_area.rotation = deg_to_rad(sight_rotation)

func inactive():
	if state == State.INACTIVE:
		return
	state = State.INACTIVE
	
	body_collision_shape.disabled = true
	player_detection_collision_shape.disabled = true
	
	player_detection_area.hide()

func active():
	if state == State.ACTIVE:
		return
	state = State.ACTIVE
	
	body_collision_shape.disabled = false
	player_detection_collision_shape.disabled = false
	
	player_detection_area.show()
	
func on_player_detected(player):
	if player is Player:
		player.found()
		exclamation.show()
		await get_tree().create_timer(0.5).timeout
		exclamation.hide()
		player.detection_manager.guard_attacking = self
		player.attack()
