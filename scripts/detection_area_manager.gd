extends Node2D

@export var player: CharacterBody2D
@export var detection_area: Area2D

@onready var r_pos: Marker2D = $RPos
@onready var l_pos: Marker2D = $LPos
@onready var d_pos: Marker2D = $DPos
@onready var u_pos: Marker2D = $UPos

func _ready() -> void:
	if detection_area:
		detection_area.body_entered.connect(on_guard_detected)
		detection_area.body_exited.connect(on_guard_undetected)

func _physics_process(delta: float) -> void:
	if player.last_dir_pressed and detection_area:
		match player.last_dir_pressed:
			"W":
				detection_area.position = u_pos.position
			"A":
				detection_area.position = l_pos.position
			"S":
				detection_area.position = d_pos.position
			"D":
				detection_area.position = r_pos.position

func on_guard_detected(guard):
	if guard is Guard:
		print("guard detected")

func on_guard_undetected(guard):
	if guard is Guard:
		print("guard undetected")
