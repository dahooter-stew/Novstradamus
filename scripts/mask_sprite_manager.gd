class_name MaskSpriteManager extends Node2D

const NOVA_MASK_3 = preload("uid://dx6awv8f4odig")
const NOVA_MASK_2 = preload("uid://clak55akoibsk")
const NOVA_MASK_1 = preload("uid://l22kprrgutwp")

@onready var sprite: Sprite2D = $Sprite2D

func update_mask_sprite(mask):
	match mask:
		0:
			sprite.texture = null
		1:
			sprite.texture = NOVA_MASK_1
		2:
			sprite.texture = NOVA_MASK_2
		3:
			sprite.texture = NOVA_MASK_3
