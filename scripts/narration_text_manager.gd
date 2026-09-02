class_name NarrationTextManager
extends Node

@export var narration_text_display: NarrationTextDisplay

func change_current_text_array(text_res):
	if text_res:
		narration_text_display.text_array = text_res.text_lines_array
