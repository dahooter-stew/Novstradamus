extends Node
class_name MenusManager

@onready var fail_screen: CanvasLayer = $"Fail Screen"
@onready var main_menu: CanvasLayer = $MainMenu

func _ready() -> void:
	fail_screen.hide()
	main_menu.hide()
	
	fail_screen.retry_button.pressed.connect(on_retry_pressed)
	fail_screen.quit_button.pressed.connect(on_quit_pressed)

	main_menu.start_button.pressed.connect(on_start_pressed)
	main_menu.exit_button.pressed.connect(on_exit_pressed)
	
func on_retry_pressed():
	print("pressed retry")
	fail_screen.hide()

func on_quit_pressed():
	print("pressed quit")
	fail_screen.hide()
	main_menu.show()

func on_start_pressed():
	print("pressed start")
	main_menu.hide()

func on_exit_pressed():
	print("pressed exit")
	main_menu.hide()
	get_tree().quit()
