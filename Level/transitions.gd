extends CanvasLayer

@onready var animation_player = $AnimationPlayer

signal transition_complete

func play_exit():
	print("Exit Animation Played")
	animation_player.play("Exit_Level")
	await Transitions.transition_complete
	play_enter()
	
func play_enter():
	print("Enter Animation Played")
	animation_player.play("Enter_Level")

func _on_animation_player_animation_finished(anim_name):
	emit_signal("transition_complete")
