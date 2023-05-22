extends Area2D
@export var next_level: String = ""
@onready var sprite = $AnimatedSprite2D

func _on_body_entered(body):
	if body is Player:
		sprite.play("Reached")
		#get_tree().change_scene_to_file(next_level)
		#Events.emit_signal("goal_reached", 1)
