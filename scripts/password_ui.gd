extends Control

@onready var keypad_button_1: TextureButton = $ColorRect2/GridContainer/KeypadButton1
@onready var keypad_button_2: TextureButton = $ColorRect2/GridContainer/KeypadButton2
@onready var keypad_button_3: TextureButton = $ColorRect2/GridContainer/KeypadButton3
@onready var keypad_button_4: TextureButton = $ColorRect2/GridContainer/KeypadButton4
@onready var keypad_button_5: TextureButton = $ColorRect2/GridContainer/KeypadButton5
@onready var keypad_button_6: TextureButton = $ColorRect2/GridContainer/KeypadButton6
@onready var keypad_button_7: TextureButton = $ColorRect2/GridContainer/KeypadButton7
@onready var keypad_button_8: TextureButton = $ColorRect2/GridContainer/KeypadButton8
@onready var keypad_button_9: TextureButton = $ColorRect2/GridContainer/KeypadButton9

@onready var keypad_enter_button: TextureButton = $ColorRect2/KeypadEnterButton

@onready var led_light_1: TextureRect = $ColorRect2/HBoxContainer/LedLight1
@onready var led_light_2: TextureRect = $ColorRect2/HBoxContainer/LedLight2
@onready var led_light_3: TextureRect = $ColorRect2/HBoxContainer/LedLight3

@onready var indicator_1: Sprite2D = $ColorRect2/GridContainer/KeypadButton1/Indicator1
@onready var indicator_2: Sprite2D = $ColorRect2/GridContainer/KeypadButton2/Indicator2
@onready var indicator_3: Sprite2D = $ColorRect2/GridContainer/KeypadButton3/Indicator3
@onready var indicator_4: Sprite2D = $ColorRect2/GridContainer/KeypadButton4/Indicator4
@onready var indicator_5: Sprite2D = $ColorRect2/GridContainer/KeypadButton5/Indicator5
@onready var indicator_6: Sprite2D = $ColorRect2/GridContainer/KeypadButton6/Indicator6
@onready var indicator_7: Sprite2D = $ColorRect2/GridContainer/KeypadButton7/Indicator7
@onready var indicator_8: Sprite2D = $ColorRect2/GridContainer/KeypadButton8/Indicator8
@onready var indicator_9: Sprite2D = $ColorRect2/GridContainer/KeypadButton9/Indicator9

var keypad_button_array: Array = []
var led_light_array: Array = []
var indicator_array: Array = []

signal keypad_button_pressed(prssed_keypad_button)

func _ready() -> void:
	keypad_enter_button.set_disabled(true)
	
	keypad_button_array = [keypad_button_1, keypad_button_2, keypad_button_3, keypad_button_3, keypad_button_4, keypad_button_5, keypad_button_6, keypad_button_7, keypad_button_8, keypad_button_9]
	led_light_array = [led_light_1, led_light_2, led_light_3]
	indicator_array = [indicator_1, indicator_2, indicator_3, indicator_4, indicator_5, indicator_6, indicator_7, indicator_8, indicator_9]

	for keypad_button in keypad_button_array:
		#print(keypad_button)
		if not keypad_button.pressed.is_connected(on_keypad_button_pressed):
			keypad_button.pressed.connect(on_keypad_button_pressed.bind(keypad_button))

func indicate_keypad_button(button_number):
	var animated_indicator = indicator_array[button_number]
	animated_indicator.show()
	animated_indicator.modulate = Color.WHITE * 2
	await get_tree().create_timer(0.3).timeout
	animated_indicator.modulate = Color.WHITE
	animated_indicator.hide()
	await get_tree().create_timer(0.3).timeout

func on_keypad_button_pressed(keypad_button):
	keypad_button_pressed.emit(keypad_button)
