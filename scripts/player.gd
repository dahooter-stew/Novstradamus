extends CharacterBody2D

enum State {
	IDLE,
	RUN,
	ATTACK,
	DEAD
}

@export_category("Stats")
@export var speed: int = 400

var state: State = State.IDLE
var move_direction: Vector2 = Vector2.ZERO

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_playback: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]

func _ready() -> void:
	animation_tree.active = true

func _physics_process(delta: float) -> void:
	movement_loop(delta)

func movement_loop(delta: float) -> void:
	move_direction = Input.get_vector("left", "right", "up", "down")
	var velocity: Vector2 = move_direction.normalized() * speed
	set_velocity(velocity)
	move_and_slide()
	
	if state == State.IDLE or state == State.RUN:
		if Input.is_action_just_pressed("left"):
			$Sprite2D.flip_h = true
		elif Input.is_action_just_pressed("right"):
			$Sprite2D.flip_h = false
	
	if move_direction != Vector2.ZERO and state == State.IDLE:
		state = State.RUN
		update_animation()
	elif move_direction == Vector2.ZERO and state == State.RUN:
		state = State.IDLE
		update_animation()

func update_animation() -> void:
	match state:
		State.IDLE:
			animation_playback.travel("idle")
		State.RUN:
			animation_playback.travel("run")
		State.ATTACK:
			animation_playback.travel("attack")
