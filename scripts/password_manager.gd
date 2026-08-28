class_name PasswordManager extends Node

@export var door: Area2D
@export var ui: Control

var password_sequence: Array

func _ready() -> void:
	ui.keypad_button_pressed.connect(on_keypad_button_pressed)
	
	start_sequence()

func generate_password():
	for i in 5:
		password_sequence.append(randi_range(0, 8))

func start_sequence():
	ui.show()
	await get_tree().create_timer(0.5).timeout
	
func indicate_password_sequence():
	for i in password_sequence:
		await ui.indicate_keypad_button(i)
	
func on_keypad_button_pressed(keypad_button):
	print(keypad_button)
