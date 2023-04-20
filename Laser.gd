extends Node2D

@onready var line = $Line2D

func _ready():
	var gradient = Gradient.new()
	gradient.set_color(0, Color.RED) # Change the color to the desired laser color
	gradient.set_color(1, Color.RED)

	var gradient_texture = Sprite2D.new()
	gradient_texture.gradient = gradient
	gradient_texture.width = 1

	line.texture = gradient_texture
