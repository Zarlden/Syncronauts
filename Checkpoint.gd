extends Area2D
var triggered = false
@onready var sprite = $AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func _on_body_entered(body):
	if not triggered:
		if body is Player:
			sprite.play("Reached")
			Events.emit_signal("checkpoint_reached", position)
			triggered = true
			await sprite.animation_finished
			sprite.play("Reached_Idle")
			
			
