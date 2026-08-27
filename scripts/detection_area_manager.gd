extends Node2D
class_name DetectionManager

@export var player: CharacterBody2D
@export var detection_area: Area2D

@onready var r_pos: Marker2D = $RPos
@onready var l_pos: Marker2D = $LPos
@onready var d_pos: Marker2D = $DPos
@onready var u_pos: Marker2D = $UPos
@onready var can_takedown: bool = false

var detected_guard_list: Array
var guard_attacking: Guard

func _ready() -> void:
	if detection_area:
		detection_area.body_entered.connect(on_guard_detected)
		detection_area.body_exited.connect(on_guard_undetected)
		detection_area.position = r_pos.position
		detection_area.rotation = 0

func _physics_process(_delta: float) -> void:
	if player.last_dir_pressed and detection_area:
		match player.last_dir_pressed:
			"W":
				detection_area.position = u_pos.position
				detection_area.rotation = deg_to_rad(90)
			"A":
				detection_area.position = l_pos.position
				detection_area.rotation = 0
			"S":
				detection_area.position = d_pos.position
				detection_area.rotation = deg_to_rad(90)
			"D":
				detection_area.position = r_pos.position
				detection_area.rotation = 0
	if guard_attacking:
		update_takedown_prompt()

func update_guard_attacking():
	guard_attacking = detected_guard_list[0]

func update_takedown_prompt():
	if guard_attacking.is_in_player_detection_area == true and player.mask == Player.Mask.STRENGTH:
		guard_attacking.takedown_prompt.show()
	else:
		guard_attacking.takedown_prompt.hide()

func on_guard_detected(guard):
	if guard is Guard:
		guard.is_in_player_detection_area = true
		#print(guard.name + " detected")
		#if player.mask == Player.Mask.STRENGTH:
			#can_takedown = true
		detected_guard_list.append(guard)
		update_guard_attacking()

func on_guard_undetected(guard):
	if guard is Guard:
		guard.is_in_player_detection_area = false
		#print(guard.name + " undetected")
		#can_takedown = false
		detected_guard_list.erase(guard)
		guard.takedown_prompt.hide()
