extends Area2D

const colourNode = preload("res://ColourNode.gd")
var barrier_colour = colourNode.colourSet.BLUE

func _ready():
	$CollisionShape2D.set_deferred("disabled", false)
	barrier_colour = $ColourNode.colour
	print(barrier_colour)

func _on_body_entered(body):
	if body is Player:
		if body.colour == barrier_colour:
			$BarrierShape/CollisionShape2D.set_deferred("disabled", true)
