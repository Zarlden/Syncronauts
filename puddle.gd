extends Node2D

const colourNode = preload("res://ColourNode.gd")

@export var puddleColour: colourNode.colourSet = colourNode.colourSet.RED
@export var SecpuddleColour = colourNode.colourSet.NONE

func _on_body_entered(body):
	if body is Player:
		if body.colour != puddleColour or body.colour != SecpuddleColour:
			body.player_died()

