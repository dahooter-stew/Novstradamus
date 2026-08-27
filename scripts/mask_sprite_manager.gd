class_name MaskSpriteManager extends Node2D

const NOVA_MASK_3 = preload("uid://dx6awv8f4odig")
const NOVA_MASK_2 = preload("uid://clak55akoibsk")
const NOVA_MASK_1 = preload("uid://l22kprrgutwp")

@onready var mask_sprite: Sprite2D = $MaskSprite

func update_mask_sprite(mask):
	match mask:
		0:
			mask_sprite.texture = null
		1:
			mask_sprite.texture = NOVA_MASK_1
		2:
			mask_sprite.texture = NOVA_MASK_2
		3:
			mask_sprite.texture = NOVA_MASK_3
