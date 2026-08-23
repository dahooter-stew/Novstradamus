extends Node2D

@onready var qte_ui: Control = $"CanvasLayer/QTE UI"
@onready var letters = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
@onready var letter_prompt_dict: Dictionary
@onready var success_count: int = 0

func update_prompt_list():
	if not letter_prompt_dict.is_empty():
		for prompt in letter_prompt_dict:
			letter_prompt_dict[prompt].show()

	letter_prompt_dict.clear()
	var letter_pick_list: Array = letters.duplicate_deep()
	for i in qte_ui.key_icon_list:
		var letter_prompt = letter_pick_list.pick_random().to_upper()
		i.get_node("KeyIconLabel").text = letter_prompt
		letter_prompt_dict[letter_prompt] = i
		letter_pick_list.erase(letter_prompt.to_lower())
	
	#print(letter_prompt_dict)

func _ready() -> void:
	update_prompt_list()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if letter_prompt_dict.has(event.as_text()):
			letter_prompt_dict[event.as_text()].hide()
			success_count += 1

func _physics_process(_delta: float) -> void:
	if success_count >= 3:
		#print("success")
		success_count = 0
		update_prompt_list()
