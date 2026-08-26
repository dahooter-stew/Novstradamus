extends Node2D

#@onready var qte_manager: Node2D = $"QTE Manager"
@onready var menus_manager: MenusManager = $"Menus Manager"
@onready var level_manager: LevelManager = $LevelManager

#var player: Player
var current_level: Level

#var guard_list: Array

func _ready() -> void:
	menus_manager.game_exited.connect(on_game_exited)
	menus_manager.game_started.connect(on_game_started)
	menus_manager.game_resetted.connect(on_game_resetted)
	
	level_manager.level_loaded.connect(on_level_loaded)
	level_manager.levels_finished.connect(on_levels_finished)

func on_game_exited():
	print("pressed exit")
	get_tree().quit()

func on_game_started():
	print("pressed start")
	level_manager.current_level_number = 1
	level_manager.play_current_level()

func on_game_resetted():
	level_manager.play_current_level()

func on_level_loaded(level):
	current_level = level
	if current_level:
		var player_children_array: Array = current_level.player.get_children()
		for child in player_children_array:
			if child.name == "QTE Manager":
				child.qte_failed.connect(on_qte_failed)

func on_levels_finished():
	print("finished levels")
	menus_manager.win_screen.show()

func on_qte_failed():
	print("qte failed")
	level_manager.unload_current_level()
	menus_manager.fail_screen.show()

#func on_qte_activated():
	#print("qte activated")
	#current_level.player.detection_manager.guard_attacking.takedown_prompt.hide()
	#
#func on_qte_deactivated():
	#print("qte deactivated")
	#await get_tree().create_timer(0.1).timeout
	#player.idle()
