extends CharacterBody2D
class_name Player

enum State {
	IDLE,
	RUN,
	ATTACK,
	DEAD
}

@export_category("Stats")
@export var speed: int = 400
@export var attack_speed: float = 0.6
@export var detection_manager: DetectionManager

var move_direction: Vector2 = Vector2.ZERO
var last_dir_pressed: String
var input_queue: Array

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_playback: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]
@onready var state_label: Label = $State
@onready var state: State = State.IDLE

signal toggle_qte

func _ready() -> void:
	animation_tree.active = true

func _input(event: InputEvent) -> void:
	var dir_keys: Array = ["W", "A", "S", "D"]
	
	if not state == State.DEAD and not state == State.ATTACK:
		if event.is_action_pressed("up"):
			input_queue.append("W")
		if event.is_action_released("up"):
			input_queue.erase("W")
		
		if event.is_action_pressed("left"):
			input_queue.append("A")
		if event.is_action_released("left"):
			input_queue.erase("A")
		
		if event.is_action_pressed("down"):
			input_queue.append("S")
		if event.is_action_released("down"):
			input_queue.erase("S")
		
		if event.is_action_pressed("right"):
			input_queue.append("D")
		if event.is_action_released("right"):
			input_queue.erase("D")
		
		if Input.is_action_just_pressed("space") and detection_manager.can_takedown:
			toggle_qte.emit()
		
	if event is InputEventKey and dir_keys.has(event.as_text()):
		if input_queue:
			last_dir_pressed = input_queue[-1]
		#print(input_queue)
		#print(last_dir_pressed)
	
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		#attack()

func _physics_process(delta: float) -> void:
	state_label.text = str(state)
	
	if not state == State.DEAD and not state == State.ATTACK:
		movement_loop(delta)

	if state == State.DEAD:
		detection_manager.detection_area

func movement_loop(_delta: float) -> void:
	move_direction = Input.get_vector("left", "right", "up", "down")
	velocity = move_direction.normalized() * speed
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
		State.DEAD:
			animation_playback.travel("dead")

func idle():
	if state == State.IDLE:
		return
	state = State.IDLE

func attack() -> void:
	if state == State.ATTACK:
		return
	state = State.ATTACK

func dead():
	if state == State.DEAD:
		return
	state = State.DEAD

	#var mouse_pos: Vector2 = get_global_mouse_position()
	#var attack_dir: Vector2 = (mouse_pos - global_position).normalized()
	#animation_tree.set("parameters/attack/BlendSpace2D/blend_position", attack_dir)
	#$Sprite2D.flip_h = attack_dir.x < 0 and abs(attack_dir.x) >= abs(attack_dir.y)
	#update_animation()
	#
	#await get_tree().create_timer(attack_speed).timeout
	#state = State.IDLE
