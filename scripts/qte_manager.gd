class_name QTEManager extends Node

@onready var qte_ui: Control = $"CanvasLayer/QTE UI"
@onready var timer: Timer = $Timer
@onready var letters = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
@onready var letter_prompt_dict: Dictionary
@onready var success_count: int = 0
@onready var is_active: bool = false

signal qte_activated
signal qte_deactivated
signal qte_succeeded
signal qte_failed

func update_prompt_list():
	letter_prompt_dict.clear()
	var letter_pick_list: Array = letters.duplicate_deep()
	for i in qte_ui.key_icon_list:
		var letter_prompt = letter_pick_list.pick_random().to_upper()
		i.get_node("KeyIconLabel").text = letter_prompt
		letter_prompt_dict[letter_prompt] = i
		letter_pick_list.erase(letter_prompt.to_lower())
	
	for prompt in letter_prompt_dict:
			letter_prompt_dict[prompt].show()
	#print(letter_prompt_dict)

func start_qte():
	qte_activated.emit()
	success_count = 0
	update_prompt_list()
	is_active = true
	qte_ui.show()
	timer.start()

func stop_qte():
	success_count = 0
	is_active = false
	qte_ui.hide()
	timer.stop()

func _ready() -> void:
	qte_ui.hide()
	
func _input(event: InputEvent) -> void:
	if is_active and event is InputEventKey and event.is_pressed():
		if letter_prompt_dict.has(event.as_text()):
			letter_prompt_dict[event.as_text()].hide()
			success_count += 1

func _process(_delta: float) -> void:
	qte_ui.progress_bar.value = (timer.get_time_left() / timer.wait_time) * 100
	#print((timer.get_time_left() / timer.wait_time) * 100)

func _physics_process(_delta: float) -> void:
	if is_active:
		if timer.is_stopped(): # Fail
			#print("fail")
			stop_qte()
			qte_failed.emit()
			
		else: # Win
			if success_count == 3:
				qte_succeeded.emit()
				#print("success")
				stop_qte()
				qte_deactivated.emit()

func on_toggle_qte():
	if not is_active: # Toggle on
		start_qte()
		#print("started qte")
	else:  # Toggle off
		stop_qte()
		qte_deactivated.emit()
		#print("cancelled qte")
	#print("toggled qte")
