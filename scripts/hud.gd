extends CanvasLayer

@onready var sly_hud: HBoxContainer = $Control/VBoxContainer/HBoxContainer
@onready var strength_hud: HBoxContainer = $Control/VBoxContainer/HBoxContainer2
@onready var sage_hud: HBoxContainer = $Control/VBoxContainer/HBoxContainer3

const highlighted_color: Color = Color(1, 1, 1)
const normal_color: Color = Color(0.5, 0.5, 0.5)

func update_mask_charge_hud(mask, charge_count):
	var icon_index: int = charge_count + 1
	var mask_icon_list: Array
	#print("icon_index: ", icon_index)
	match mask:
		1:
			mask_icon_list = sly_hud.get_children()
			mask_icon_list[icon_index].hide()
		2:
			mask_icon_list = strength_hud.get_children()
			mask_icon_list[icon_index].hide()
		3:
			mask_icon_list = sage_hud.get_children()
			mask_icon_list[icon_index].hide()

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
