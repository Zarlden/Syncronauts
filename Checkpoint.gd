extends Area2D
var triggered = false
@onready var sprite = $AnimatedSprite2D

func _ready():
	if multiplayer.is_server():
		print("Set Current Checkpoint State to " + $AnimatedSprite2D.animation)
		$Network.checkpoint_animation_state = $AnimatedSprite2D.animation
		print("Server Set Checkpoint State to " + $Network.checkpoint_animation_state)
	

func _on_body_entered(body):
	if not triggered:
		if body is Player:
			sprite.play("Reached")
			if multiplayer.is_server():
				$Network.checkpoint_animation_state = $AnimatedSprite2D.animation
				print("Server Set Checkpoint State to " + $Network.checkpoint_animation_state)
			Events.emit_signal("checkpoint_reached", position)
			triggered = true
			await sprite.animation_finished
			sprite.play("Reached_Idle")


func _on_multiplayer_synchronizer_synchronized():
	if !multiplayer.is_server():
		print("Set Client Checkpoint State to " + $Network.checkpoint_animation_state)
		$AnimatedSprite2D.play($Network.checkpoint_animation_state)
