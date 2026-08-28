class_name PasswordDoor extends StaticBody2D

@export var password_manager: PasswordManager
@export var password_prompt: Control
@onready var collision_body: CollisionShape2D = $CollisionBody
@onready var sprite: Sprite2D = $DoorSprite

@onready var is_in_player_detection_area: bool = false
