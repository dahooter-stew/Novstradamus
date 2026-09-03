class_name NarrationTextDisplay
extends Control

@export var pause_duration: float

@onready var label: RichTextLabel = $RichTextLabel
@onready var next_button: TextureButton = $NextButton
@onready var skip_button: TextureButton = $SkipButton

@onready var text_array: Array
@onready var current_line_index: int = 0

signal line_display_finished
signal text_array_display_completed

func _ready() -> void:
	line_display_finished.connect(_on_line_display_finished)
	next_button.pressed.connect(_on_next_button_pressed)
	skip_button.pressed.connect(_on_skip_button_pressed)

func display_narration_text_line():
	var current_line = text_array[current_line_index]
	label.text = current_line
	var current_line_char: int = 0
	for character in current_line:
		current_line_char += 1
		label.visible_characters = current_line_char
		if character == "," or character == ".":
			for x in range(20): await get_tree().physics_frame
		else:
			for x in range(3): await get_tree().physics_frame
	line_display_finished.emit()

func _on_line_display_finished():
	next_button.show()

func _on_next_button_pressed():
	next_button.hide()
	if current_line_index >= text_array.size() - 1:
		current_line_index = 0
		text_array_display_completed.emit()
	else:
		current_line_index += 1
		display_narration_text_line()

func _on_skip_button_pressed():
	current_line_index = 0
	#hide()
	text_array_display_completed.emit()
