extends StaticBody2D
class_name  Barrier

const colourNode = preload("res://ColourNode.gd")
const COLOR = colourNode.colourSet.BLUE

func _ready():
	$CollisionShape2D.set_deferred("disabled", false)
