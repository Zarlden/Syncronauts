extends Node2D


##TODO want to apply function to all children -- initially wanted color cascade but maybe nvm

# Called when the node enters the scene tree for the first time.
var children = []

func _ready():
	for node in get_children():
		if node != $"Pressure Plate":
			children += node

func filter_red():
	for child in children:
		if child is Barrier:
			if child.barrier_colour == $ColourNode.colourSet.RED:
				remove_child(child)
			elif child.barrier_colour == $ColourNode.colourSet.PURPLE:
				remove_child(child)
				add_child()

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
