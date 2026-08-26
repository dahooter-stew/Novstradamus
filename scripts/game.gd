extends Node2D

@onready var qte_manager: Node2D = $"QTE Manager"
@onready var menus_manager: MenusManager = $"Menus Manager"
@onready var level_manager: LevelManager = $LevelManager

var player: Player

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

func on_level_loaded(level_player):
	player = level_player
	#player.qte_manager.qte_succeeded.connect(on_qte_succeeded)
	player.qte_manager.qte_failed.connect(on_qte_failed)
	player.qte_manager.qte_activated.connect(on_qte_activated)
	player.qte_manager.qte_deactivated.connect(on_qte_deactivated)

func on_levels_finished():
	print("finished levels")
	menus_manager.win_screen.show()

func on_qte_failed():
	print("qte failed")
	level_manager.unload_current_level()
	menus_manager.fail_screen.show()

func on_qte_activated():
	print("qte activated")
	player.detection_manager.guard_attacking.takedown_prompt.hide()
	
func on_qte_deactivated():
	print("qte deactivated")
	await get_tree().create_timer(0.1).timeout
	player.idle()
