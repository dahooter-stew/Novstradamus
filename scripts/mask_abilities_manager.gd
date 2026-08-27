class_name MaskAbilitiesManager extends Node

@export var mask_charge_counter: Dictionary[String, int]

func update_mask_charge(mask_name):
	mask_charge_counter[mask_name] -= 1
	print(mask_charge_counter[mask_name])
