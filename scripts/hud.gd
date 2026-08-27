extends CanvasLayer

@onready var sly_hud: HBoxContainer = $Control/VBoxContainer/HBoxContainer
@onready var strength_hud: HBoxContainer = $Control/VBoxContainer/HBoxContainer2
@onready var sage_hud: HBoxContainer = $Control/VBoxContainer/HBoxContainer3

const highlighted_color: Color = Color(1, 1, 1)
const normal_color: Color = Color(0.5, 0.5, 0.5)

func update_indicated_active_mask(mask):
	match mask:
		0:
			sly_hud.modulate = normal_color
			strength_hud.modulate = normal_color
			sage_hud.modulate = normal_color
		1:
			sly_hud.modulate = highlighted_color
			strength_hud.modulate = normal_color
			sage_hud.modulate = normal_color
		2:
			sly_hud.modulate = normal_color
			strength_hud.modulate = highlighted_color
			sage_hud.modulate = normal_color
		3:
			sly_hud.modulate = normal_color
			strength_hud.modulate = normal_color
			sage_hud.modulate = highlighted_color
