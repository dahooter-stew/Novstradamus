class_name PasswordManager extends Node

@export var door: Area2D
@export var ui: Control

func _ready() -> void:
	ui.keypad_button_pressed.connect(on_keypad_button_pressed)

func on_keypad_button_pressed(keypad_button):
	print(keypad_button)
