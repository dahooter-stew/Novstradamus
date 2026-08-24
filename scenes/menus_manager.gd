extends Node

@onready var fail_screen: CanvasLayer = $"Fail Screen"

func _ready() -> void:
	fail_screen.hide()
	fail_screen.retry_button.pressed.connect(on_retry_pressed)
	fail_screen.quit_button.pressed.connect(on_quit_pressed)

func on_retry_pressed():
	print("pressed retry")

func on_quit_pressed():
	print("pressed quit")
