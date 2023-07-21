extends Node2D


##TODO want to apply function to all children -- initially wanted color cascade but maybe nvm

# Collection of children (list of 1 for a single child)

# Remove
# Drain colour

# Called when the node enters the scene tree for the first time.

enum types {
	REMOVE,
	REMOVE_RED,
	REMOVE_BLUE
}

@export var type: types = types.REMOVE

var children = []
@onready var red_texture = load("res://Interactable_Objects/Barrier/RedBarrier.png")
@onready var black_texture = load("res://Interactable_Objects/Barrier/BlackBarrier.png")
@onready var blue_texture = load("res://Interactable_Objects/Barrier/BlueBarrier.png")
@onready var purple_texture = load("res://Interactable_Objects/Barrier/PurpleBarrier.png")

@onready var colours = $ColourNode.colourSet

#var colour_arithmetic = {
#	"sub": {
#		[colours.PURPLE, colours.RED]: colours.BLUE,
#		[colours.PURPLE, colours.BLUE]: colours.RED,
#		[colours.RED, colours.RED]: colours.BLACK,
#		[colours.BLUE, colours.BLUE]: colours.BLACK, 
#	},
#	"add": {
#		[colours.BLUE, colours.RED]: colours.BLUE,
#		[colours.PURPLE, colours.BLUE]: colours.RED,
#		[colours.RED, colours.RED]: colours.BLACK,
#		[colours.BLUE, colours.BLUE]: colours.BLACK, 
#	}
#	
#}

func remove(children):
	for child in get_children():
		if child is Barrier:
			children += child
			remove_child(child)

func add(children):
	for child in children:
		add_child(child)
	children.clear()

func subtract_red(children):
	for child in get_children():
		if child is Barrier:
			if child.barrier_colour == $ColourNode.colourSet.RED:
				child.change_texture(black_texture)
				child.barrier_colour = $ColourNode.colourSet.BLACK
			elif child.barrier_colour == $ColourNode.colourSet.PURPLE:
				child.change_texture(blue_texture)
				child.barrier_colour = $ColourNode.colourSet.BLUE

func add_red(children):
	for child in get_children():
		if child is Barrier:
			if child.barrier_colour == $ColourNode.colourSet.BLACK:
				child.change_texture(red_texture)
				child.barrier_colour = $ColourNode.colourSet.RED
			elif child.barrier_colour == $ColourNode.colourSet.BLUE:
				child.change_texture(purple_texture)
				child.barrier_colour = $ColourNode.colourSet.PURPLE


func subtract_blue(children):
	for child in get_children():
		if child is Barrier:
			if child.barrier_colour == $ColourNode.colourSet.BLUE:
				child.change_texture(black_texture)
				child.barrier_colour = $ColourNode.colourSet.BLACK
			elif child.barrier_colour == $ColourNode.colourSet.PURPLE:
				child.change_texture(red_texture)
				child.barrier_colour = $ColourNode.colourSet.RED

func add_blue(children):
	for child in get_children():
		if child is Barrier:
			if child.barrier_colour == $ColourNode.colourSet.BLACK:
				child.change_texture(blue_texture)
				child.barrier_colour = $ColourNode.colourSet.BLUE
			elif child.barrier_colour == $ColourNode.colourSet.RED:
				child.change_texture(purple_texture)
				child.barrier_colour = $ColourNode.colourSet.PURPLE


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
			match type:
				types.REMOVE:
					remove(children)
				types.REMOVE_RED:
					subtract_red(children)
				types.REMOVE_BLUE:
					subtract_blue(children)


func _on_pressure_plate_pressure_plate_pressed():
	for child in children:
		if not child:
			match type:
				types.REMOVE:
					add(children)
				types.REMOVE_RED:
					add_red(children)
				types.REMOVE_BLUE:
					add_blue(children)
