extends CharacterBody2D
class_name Guard

enum State {
	ACTIVE,
	INACTIVE
}

@onready var takedown_prompt: Control = $TakedownPrompt
@onready var body_collision_shape: CollisionShape2D = $BodyCollisionShape
@onready var state: State = State.ACTIVE

func inactive():
	if state == State.INACTIVE:
		return
	state = State.INACTIVE
	
	body_collision_shape.disabled = true

func active():
	if state == State.ACTIVE:
		return
	state = State.ACTIVE
	
	body_collision_shape.disabled = false
