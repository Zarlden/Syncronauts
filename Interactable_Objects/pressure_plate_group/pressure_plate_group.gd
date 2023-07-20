extends Node2D


# Called when the node enters the scene tree for the first time.
var children = []

func _ready():
	for node in get_children():
		if node != $"Pressure Plate":
			children += node


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_pressure_plate_pressure_plate_released():
	for child in children:
		if child:
			remove_child(child)


func _on_pressure_plate_pressure_plate_pressed():
	for child in children:
		if not child:
			add_child(child)
