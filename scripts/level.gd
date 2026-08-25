class_name Level extends Node2D

@export var player: Player
@export var next_level_number: int

@onready var level_change_area: Area2D = $LevelChangeArea

signal player_entered_level_change_area

func _ready() -> void:
	level_change_area.body_entered.connect(on_body_entered)

func on_body_entered(body):
	if body is Player:
		player_entered_level_change_area.emit(next_level_number)
