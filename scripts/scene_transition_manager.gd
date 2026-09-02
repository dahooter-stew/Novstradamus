class_name SceneTransitionAnimationManager
extends Node

@onready var black_rect: ColorRect = $CanvasLayer/ColorRect
var scene_transition_anim_tween: Tween

func play_scene_fade_out():
	black_rect.modulate.a = 0
	black_rect.show()
	
	if scene_transition_anim_tween:
		scene_transition_anim_tween.kill()
	
	scene_transition_anim_tween = create_tween().set_trans(Tween.TRANS_SINE)
	scene_transition_anim_tween.tween_property(black_rect, "modulate:a", 1, 1)
	await scene_transition_anim_tween.finished
	
	black_rect.hide()
	
func play_scene_fade_in():
	black_rect.modulate.a = 1
	black_rect.show()
	
	if scene_transition_anim_tween:
		scene_transition_anim_tween.kill()
	
	scene_transition_anim_tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	scene_transition_anim_tween.tween_property(black_rect, "modulate:a", 0, 1)
	await scene_transition_anim_tween.finished
	
	black_rect.hide()
