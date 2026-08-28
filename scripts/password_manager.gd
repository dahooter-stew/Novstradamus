class_name PasswordManager extends Node

@export var door: PasswordDoor
@export var ui: Control

@onready var attempts_remaining: int = 3

var password_sequence: Array

func _ready() -> void:
	ui.keypad_button_pressed.connect(on_keypad_button_pressed)
	
	#start_sequence()

func _process(delta: float) -> void:
	pass

func generate_password_sequence():
	var generated_sequence: Array
	for i in 5:
		generated_sequence.append(randi_range(0, 8))
	return generated_sequence

func start_sequence():
	ui.show()
	await get_tree().create_timer(0.7).timeout
	
func indicate_password_sequence():
	for i in password_sequence:
		await ui.indicate_keypad_button(i)
	


func on_keypad_button_pressed(keypad_button):
	print(keypad_button)
