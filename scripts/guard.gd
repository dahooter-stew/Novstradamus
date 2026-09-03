extends CharacterBody2D
class_name Guard

enum State {
	ACTIVE,
	INACTIVE,
	ATTACK
}

@export var sight_rotation: float = 0
@export var is_patrol: bool

@onready var takedown_prompt: Control = $TakedownPrompt
@onready var sprite: AnimatedSprite2D = $GuardSprite
@onready var body_collision_shape: CollisionShape2D = $BodyCollisionShape
@onready var player_detection_area: Area2D = $PlayerDetectionArea
@onready var player_detection_collision_shape: CollisionShape2D = $PlayerDetectionArea/PlayerDetectionCollisionShape
@onready var exclamation: Label = $Exclamation
@onready var marker: Marker2D = $PlayerDetectionArea/Marker2D
@onready var state: State = State.ACTIVE
@onready var is_in_player_detection_area: bool = false

@onready var label: Label = $Label

signal inactivated

func _ready() -> void:
	player_detection_area.body_entered.connect(on_player_detected)
	player_detection_area.rotation = deg_to_rad(sight_rotation)
	#sight_line_offset = player_detection_area.position.y
	#print(sight_line_offset)

func _physics_process(_delta: float) -> void:
	#label.text = str(state)
	
	#if not is_patrol:
		#player_detection_area.rotation = deg_to_rad(sight_rotation)
		
	var facing_angle = rad_to_deg(player_detection_area.global_position.angle_to_point(marker.global_position))
	#label.text = str(facing_angle)
	if not is_patrol or (is_patrol and state != State.ACTIVE):
		if facing_angle <= -45 and facing_angle >= -135: # Up
			sprite.play("idle_up")
		elif (facing_angle < -135 and facing_angle >= -180) or (facing_angle < 135 and facing_angle >= 180): # Left
			sprite.play("idle_left")
		elif facing_angle >= 45 and facing_angle <= 135: # Down
			sprite.play("idle_down")
		elif (facing_angle < 45 and facing_angle >= 0) or (facing_angle > -45 and facing_angle <= 0): # Right
			sprite.play("idle_right")
	else:
		if facing_angle <= -45 and facing_angle >= -135: # Up
			sprite.play("walk_up")
		elif (facing_angle < -135 and facing_angle >= -180) or (facing_angle <= 135 and facing_angle >= 180): # Left
			sprite.play("walk_left")
		elif facing_angle >= 45 and facing_angle <= 135: # Down
			sprite.play("walk_down")
		elif (facing_angle < 45 and facing_angle >= 0) or (facing_angle > -45 and facing_angle <= 0): # Right
			sprite.play("walk_right")
	

func inactive():
	if state == State.INACTIVE:
		return
	state = State.INACTIVE
	
	body_collision_shape.disabled = true
	player_detection_collision_shape.disabled = true
	
	player_detection_area.hide()
	
	inactivated.emit()

func active():
	if state == State.ACTIVE:
		return
	state = State.ACTIVE
	
	body_collision_shape.disabled = false
	player_detection_collision_shape.disabled = false
	
	player_detection_area.show()

func show_detection_prompt():
	exclamation.show()
	await get_tree().create_timer(0.5).timeout
	exclamation.hide()

func on_player_detected(player):
	if player is Player:
		state = State.ATTACK
		player.found()
		await show_detection_prompt()
		
		if player.mask == player.Mask.STRENGTH:
			player.detection_manager.guard_attacking = self
			player.attack()
		else:
			player.qte_manager.qte_failed.emit()
			
