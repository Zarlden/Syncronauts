extends Node2D

const colourNode = preload("res://ColourNode.gd")

@export var puddleColour: colourNode.colourSet = colourNode.colourSet.RED

func _on_body_entered(body):
	if body is Player:
		if body.colour != puddleColour:
			body.player_died()

