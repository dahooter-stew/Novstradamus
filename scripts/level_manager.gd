extends Node
class_name LevelManager

@onready var current_level_number: int = 1

signal level_loaded

func play_current_level():
	print("res://scenes/levels/level_" + str(current_level_number) + ".tscn")
	if get_children():
		get_child(0).queue_free()
	
	var current_level_instance = load("res://scenes/levels/level_" + str(current_level_number) + ".tscn").instantiate()
	add_child(current_level_instance)
	current_level_instance.player_entered_level_change_area.connect(on_player_entered_level_change_area)
	
	if current_level_instance is Level:
		level_loaded.emit(current_level_instance.player)

func on_player_entered_level_change_area(next_level_number):
	current_level_number = next_level_number
	play_current_level()
