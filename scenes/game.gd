extends Node2D

@onready var player: Player = $Player
@onready var qte_manager: Node2D = $"QTE Manager"

var guard_list: Array

func _ready() -> void:
	guard_list.append(find_children("*", "Guard"))
	qte_manager.player = player
	player.toggle_qte.connect(qte_manager.on_toggle_qte)
