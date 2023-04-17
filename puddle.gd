extends Node2D

enum colour {
	RED,
	GREEN,
	BLUE,
	YELLOW
}

@export var puddleColour: colour = colour.RED
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_body_entered(body):
	if body is Player:
		if body.playerColour != puddleColour:
			body.player_died()
