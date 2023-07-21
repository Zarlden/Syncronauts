extends Node2D


##TODO want to apply function to all children -- initially wanted color cascade but maybe nvm

# Collection of children (list of 1 for a single child)

# Remove
# Drain colour

# Called when the node enters the scene tree for the first time.

var children = []
@onready var red_texture = load("res://Interactable_Objects/Barrier/RedBarrier.png")
@onready var black_texture = load("res://Interactable_Objects/Barrier/BlackBarrier.png")
@onready var blue_texture = load("res://Interactable_Objects/Barrier/BlueBarrier.png")

func remove(children):
	for child in get_children():
		if child is Barrier:
			children += child
			remove_child(child)

func add(children):
	for child in children:
		add_child(child)

func remove_red(children):
	for child in get_children():
		if child is Barrier and child.barrier_colour == $ColourNode.colourSet.RED:
			child.change_texture()

func _ready():
	for node in get_children():
		if node != $"Pressure Plate":
			children += node

func filter_red():
	for child in children:
		if child is Barrier:
			# Make it black
			if child.barrier_colour == $ColourNode.colourSet.RED:
				remove_child(child)
			# Make it blue
			elif child.barrier_colour == $ColourNode.colourSet.PURPLE:
				remove_child(child)

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
