class_name NarrationTextManager
extends Node

@export var narration_text_display: NarrationTextDisplay
@onready var canvas_layer: CanvasLayer = $CanvasLayer

var current_text_res: String

func change_current_text_array(text_res):
	if text_res and text_res is NarrationText:
		narration_text_display.text_array = text_res.text_lines_array
		current_text_res = text_res.resource_path.get_file().get_basename()
