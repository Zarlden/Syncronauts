extends Node2D

# Check each portal body, if a player enters, set
# their position to the other portal

var p1_pos = null
var p2_pos = null

# Called when the node enters the scene tree for the first time.
func _ready():


	p1_pos = $Portal1.get_position()
	p2_pos = $Portal2.get_position()
	print(p1_pos, p2_pos)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_portal_1_body_entered(body):
	if body is Player:
		body.set_position(p2_pos)


func _on_portal_2_body_entered(body):
	if body is Player:
		body.set_position(p1_pos)
