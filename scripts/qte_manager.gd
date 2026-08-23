extends Node2D

@onready var qte_ui: Control = $"CanvasLayer/QTE UI"
@onready var timer: Timer = $Timer
@onready var letters = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
@onready var letter_prompt_dict: Dictionary
@onready var success_count: int = 0
@onready var is_active: bool = false

signal qte_succeeded
signal qte_failed

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

func start_qte():
	is_active = true
	qte_ui.show()
	update_prompt_list()
	timer.start()

func stop_qte():
	is_active = false
	qte_ui.hide()
	timer.stop()

func _ready() -> void:
	qte_ui.hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("space") and not is_active:
		start_qte()

	if event is InputEventKey and event.is_pressed():
		if letter_prompt_dict.has(event.as_text()):
			letter_prompt_dict[event.as_text()].hide()
			success_count += 1

func _process(_delta: float) -> void:
	qte_ui.progress_bar.value = (timer.get_time_left() / timer.wait_time) * 100

func _physics_process(_delta: float) -> void:
	if is_active:
		if timer.is_stopped():
			qte_failed.emit()
			print("fail")
			stop_qte()
		else:
			if success_count >= 3:
				#qte_succeeded.emit()
				print("success")
				success_count = 0
				stop_qte()
