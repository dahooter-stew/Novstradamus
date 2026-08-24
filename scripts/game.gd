extends Node2D

@onready var player: Player = $Player
@onready var qte_manager: Node2D = $"QTE Manager"

var guard_list: Array

func _ready() -> void:
	guard_list.append(find_children("*", "Guard"))
	qte_manager.player = player
	player.toggle_qte.connect(qte_manager.on_toggle_qte)
	qte_manager.qte_succeeded.connect(on_qte_succeeded)
	qte_manager.qte_failed.connect(on_qte_failed)
	qte_manager.qte_activated.connect(on_qte_activated)
	qte_manager.qte_deactivated.connect(on_qte_deactivated)

func on_qte_succeeded():
	print("qte succeeded")
	player.detection_manager.guard_attacking.inactive()

func on_qte_failed():
	print("qte failed")

func on_qte_activated():
	print("qte activated")
	player.attack()
	player.detection_manager.guard_attacking.takedown_prompt.hide()
	
func on_qte_deactivated():
	print("qte deactivated")
	await get_tree().create_timer(0.1).timeout
	player.idle()
