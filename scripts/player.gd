extends CharacterBody2D

enum State {
	IDLE,
	RUN,
	ATTACK,
	DEAD
}

@export_category("Stats")
@export var speed: int = 400
@export var attack_speed: float = 0.6

var state: State = State.IDLE
var move_direction: Vector2 = Vector2.ZERO

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_playback: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]

func _ready() -> void:
	animation_tree.active = true

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		attack()

func _physics_process(delta: float) -> void:
	if not state == State.ATTACK:
		movement_loop(delta)

func movement_loop(delta: float) -> void:
	move_direction = Input.get_vector("left", "right", "up", "down")
	var velocity: Vector2 = move_direction.normalized() * speed
	set_velocity(velocity)
	move_and_slide()
	
	if state == State.IDLE or state == State.RUN:
		if Input.is_action_pressed("left"):
			$Sprite2D.flip_h = true
		elif Input.is_action_pressed("right"):
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

func attack() -> void:
	if state == State.ATTACK:
		return
		
	state = State.ATTACK
	
	var mouse_pos: Vector2 = get_global_mouse_position()
	var attack_dir: Vector2 = (mouse_pos - global_position).normalized()
	animation_tree.set("parameters/attack/BlendSpace2D/blend_position", attack_dir)
	$Sprite2D.flip_h = attack_dir.x < 0 and abs(attack_dir.x) >= abs(attack_dir.y)
	update_animation()
	
	await get_tree().create_timer(attack_speed).timeout
	state = State.IDLE
