extends Control

@onready var button_1: TextureButton = $ColorRect2/GridContainer/TextureButton
@onready var button_2: TextureButton = $ColorRect2/GridContainer/TextureButton2
@onready var button_3: TextureButton = $ColorRect2/GridContainer/TextureButton3
@onready var button_4: TextureButton = $ColorRect2/GridContainer/TextureButton4
@onready var button_5: TextureButton = $ColorRect2/GridContainer/TextureButton5
@onready var button_6: TextureButton = $ColorRect2/GridContainer/TextureButton6
@onready var button_7: TextureButton = $ColorRect2/GridContainer/TextureButton7
@onready var button_8: TextureButton = $ColorRect2/GridContainer/TextureButton8
@onready var button_9: TextureButton = $ColorRect2/GridContainer/TextureButton9

@onready var led_1: TextureRect = $ColorRect2/HBoxContainer/TextureRect
@onready var led_2: TextureRect = $ColorRect2/HBoxContainer/TextureRect2
@onready var led_3: TextureRect = $ColorRect2/HBoxContainer/TextureRect3

var button_array: Array = []
var led_array: Array = []

signal keypad_button_pressed(prssed_keypad_button)

func _ready() -> void:
	button_array = [button_1, button_2, button_3, button_3, button_4, button_5, button_6, button_7, button_8, button_9]
	led_array = [led_1, led_2, led_3]

	for button in button_array:
		button.pressed.connect(on_keypad_button_pressed.bind(button))

func on_keypad_button_pressed(keypad_button):
	keypad_button_pressed.emit(keypad_button)
