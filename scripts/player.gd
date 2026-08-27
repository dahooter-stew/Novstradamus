extends CharacterBody2D
class_name Player

enum State {
	IDLE,
	RUN,
	ATTACK,
	FOUND,
	DEAD
}

enum Mask {
	NONE,
	SLY,
	STRENGTH,
	SAGE
}

@export_category("Stats")
@export var speed: int = 400
@export var invisibility_duration: int = 5
@export var detection_manager: DetectionManager

var move_direction: Vector2 = Vector2.ZERO
var last_dir_pressed: String
var input_queue: Array
var prev_dir: Vector2
var mask: Mask

@onready var sprite: Sprite2D = $NovaSpritesheet
@onready var mask_abilities_manager: MaskAbilitiesManager = $MaskAbilitiesManager
@onready var mask_sprite_manager: MaskSpriteManager = $MaskSpriteManager
@onready var hud: CanvasLayer = $HUD
@onready var qte_manager: Node = $"QTE Manager"
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_playback: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]
@onready var state_label: Label = $StateDebug
@onready var state: State = State.IDLE

signal toggle_qte
signal mask_changed

func _ready() -> void:
	hud.show()
	hud.update_indicated_active_mask(mask)
	
	toggle_qte.connect(qte_manager.on_toggle_qte)
	qte_manager.qte_succeeded.connect(on_qte_succeeded)
	qte_manager.qte_failed.connect(on_qte_failed)
	qte_manager.qte_activated.connect(on_qte_activated)
	qte_manager.qte_deactivated.connect(on_qte_deactivated)
	
	mask_changed.connect(mask_sprite_manager.update_mask_sprite)
	mask_changed.connect(hud.update_indicated_active_mask)
	
	animation_tree.active = true
	
	print(collision_layer)

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
		
		# Mask Ability Activation
		if Input.is_action_just_pressed("space"):
			if mask == Mask.STRENGTH:
				if detection_manager.guard_attacking and mask_abilities_manager.mask_charge_counter["STRENGTH"] > 0:
					detection_manager.guard_attacking.on_player_detected(self)

			if mask == Mask.SLY:
				print("SLY")
				if mask_abilities_manager.mask_charge_counter["SLY"] > 0:
					set_collision_layer_value(1, false)
					set_collision_layer_value(5, true)
					set_collision_mask_value(4, false)
					sprite.modulate.a = 0.5
					await get_tree().create_timer(invisibility_duration).timeout
					set_collision_layer_value(1, true)
					set_collision_layer_value(5, false)
					set_collision_mask_value(4, true)
					sprite.modulate.a = 1
		
		# Mask Selection
		if event.is_action_pressed("1"):
			mask = Mask.SLY
			mask_changed.emit(mask)
			
		elif event.is_action_pressed("2"):
			mask = Mask.STRENGTH
			#print(mask)
			mask_changed.emit(mask)
		
		elif event.is_action_pressed("3"):
			mask = Mask.SAGE
			#print(mask)
			mask_changed.emit(mask)
			
		elif event.is_action_pressed("4"):
			mask = Mask.NONE
			#print(mask)
			mask_changed.emit(mask)
		
	if event is InputEventKey:
		if dir_keys.has(event.as_text()):
			if input_queue:
				last_dir_pressed = input_queue[-1]
	
		#print(input_queue)
		#print(last_dir_pressed)

func _physics_process(delta: float) -> void:
	state_label.text = str(state)
	
	if not state == State.DEAD and not state == State.ATTACK and not state == State.FOUND:
		movement_loop(delta)

func movement_loop(_delta: float) -> void:
	move_direction = Input.get_vector("left", "right", "up", "down")
	velocity = move_direction.normalized() * speed
	move_and_slide()
	
	if state == State.IDLE or state == State.RUN:
		if Input.is_action_pressed("left"):
			$NovaSpritesheet.flip_h = true
		elif Input.is_action_pressed("right"):
			$NovaSpritesheet.flip_h = false
	
	if move_direction != Vector2.ZERO:
		animation_tree.set("parameters/walk/BlendSpace2D/blend_position", move_direction)
		animation_tree.set("parameters/idle/BlendSpace2D/blend_position", move_direction)
	
	if move_direction != Vector2.ZERO and state == State.IDLE:
		state = State.RUN
		update_animation()
		
	elif move_direction == Vector2.ZERO and state == State.RUN:
		idle()

func update_animation() -> void:
	match state:
		State.IDLE:
			animation_playback.travel("idle")
		State.RUN:
			animation_playback.travel("walk")
			#print("walk")
		State.ATTACK:
			animation_playback.travel("idle")
		State.DEAD:
			animation_playback.travel("idle")
		State.FOUND:
			animation_playback.travel("idle")

func idle():
	if state == State.IDLE:
		return
	state = State.IDLE
	update_animation()
	#print("idle")

func found():
	if state == State.FOUND:
		return
	state = State.FOUND
	update_animation()
	#print("found")

func attack() -> void:
	if state == State.ATTACK:
		return
	state = State.ATTACK
	update_animation()
	#print("attack")
	toggle_qte.emit()

func dead():
	if state == State.DEAD:
		return
	state = State.DEAD
	update_animation()
	#print("dead")

func on_qte_succeeded():
	#print("qte succeeded")
	detection_manager.guard_attacking.inactive()
	mask_abilities_manager.update_mask_charge("STRENGTH")
	hud.update_mask_charge_hud(Mask.STRENGTH, mask_abilities_manager.mask_charge_counter["STRENGTH"])
	#detection_manager.update_guard_attacking()
	idle()

func on_qte_failed():
	#print("qte failed")
	dead()

func on_qte_activated():
	#print("qte activated")
	detection_manager.guard_attacking.takedown_prompt.hide()
	
func on_qte_deactivated():
	#print("qte deactivated")
	await get_tree().create_timer(0.1).timeout
	idle()

	#var mouse_pos: Vector2 = get_global_mouse_position()
	#var attack_dir: Vector2 = (mouse_pos - global_position).normalized()
	#animation_tree.set("parameters/attack/BlendSpace2D/blend_position", attack_dir)
	#$NovaSpritesheet.flip_h = attack_dir.x < 0 and abs(attack_dir.x) >= abs(attack_dir.y)
	#update_animation()
	#
	#await get_tree().create_timer(attack_speed).timeout
	#state = State.IDLE
