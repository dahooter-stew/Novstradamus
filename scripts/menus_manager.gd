extends Node
class_name MenusManager

@onready var fail_screen: CanvasLayer = $"Fail Screen"
@onready var main_menu: CanvasLayer = $MainMenu
@onready var win_screen: CanvasLayer = $WinScreen

signal game_started
signal game_exited
signal game_resetted

func _ready() -> void:
	main_menu.show()
	fail_screen.hide()
	win_screen.hide()
	
	fail_screen.retry_button.pressed.connect(on_retry_pressed)
	fail_screen.quit_button.pressed.connect(on_quit_pressed)

	main_menu.start_button.pressed.connect(on_start_pressed)
	main_menu.exit_button.pressed.connect(on_exit_pressed)
	
	win_screen.return_main_menu_button.pressed.connect(on_return_main_menu_button_pressed)

func on_retry_pressed():
	print("pressed retry")
	fail_screen.hide()
	game_resetted.emit()

func on_quit_pressed():
	print("pressed quit")
	fail_screen.hide()
	main_menu.show()

func on_start_pressed():
	main_menu.hide()
	game_started.emit()

func on_exit_pressed():
	main_menu.hide()
	game_exited.emit()

func on_return_main_menu_button_pressed():
	win_screen.hide()
	main_menu.show()
