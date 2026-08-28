class_name PasswordManager extends Node

@export var door: PasswordDoor
@export var ui: Control
@export var ui_canvas_layer: CanvasLayer
@export var password_length: int

@onready var attempts_remaining: int = 3
@onready var can_input: bool = false

var password_sequence: Array
var player_input_sequence: Array

signal door_hacking_succeeded
signal door_hacking_failed

func _ready() -> void:
	ui.keypad_button_pressed.connect(on_keypad_button_pressed)
	ui.keypad_enter_button.pressed.connect(on_keypad_enter_button_pressed)
	
	#start_sequence()

func _process(delta: float) -> void:
	if can_input:
		for button in ui.keypad_button_array:
			button.set_disabled(false)
	else:
		for button in ui.keypad_button_array:
			button.set_disabled(true)

func generate_password_sequence():
	var generated_sequence: Array
	for i in password_length:
		generated_sequence.append(randi_range(0, 8))
	return generated_sequence

func start_sequence():
	ui_canvas_layer.show()
	can_input = false
	await start_player_inputting_sequence()
	
func indicate_password_sequence():
	can_input = false
	for i in password_sequence:
		await ui.indicate_keypad_button(i)
	can_input = true

func start_player_inputting_sequence():
	await get_tree().create_timer(0.5).timeout
	ui.keypad_enter_button.set_disabled(true)
	player_input_sequence = []
	password_sequence = generate_password_sequence()
	print(password_sequence)
	await indicate_password_sequence()

func on_keypad_button_pressed(keypad_button):
	var player_input: int = int(str(keypad_button.name)[-1]) - 1
	if player_input_sequence.size() <= password_length - 1:
		player_input_sequence.append(player_input)
		print(player_input_sequence)
		if player_input_sequence.size() > password_length - 1:
			can_input = false
			ui.keypad_enter_button.set_disabled(false)

func on_keypad_enter_button_pressed():
	print("entered")
	ui.keypad_enter_button.set_disabled(true)
	if player_input_sequence == password_sequence:
		door_hacking_succeeded.emit()
		door.collision_body.set_disabled(true)
		door.sprite.self_modulate = Color(0.5, 0.5, 0.5)
		ui_canvas_layer.hide()
		print("success")
	else:
		if attempts_remaining > 1:
			attempts_remaining -= 1
			print("failed, ", attempts_remaining," remaining")
			start_player_inputting_sequence()
		else:
			print("caught")
			ui_canvas_layer.hide()
			door_hacking_failed.emit()
		#ui_canvas_layer.hide()
		#door.self_modulate.
