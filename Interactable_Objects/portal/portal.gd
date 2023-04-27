extends Node2D

# Check each portal body, if a player enters, set
# their position to the other portal
var p1_pos = null
var p2_pos = null
var portal_lock = false

# Called when the node enters the scene tree for the first time.
func _ready():
	p1_pos = $Portal1.get_position()
	p2_pos = $Portal2.get_position()


func teleport(player, to):
	if not portal_lock:
		if not portal_lock:
			player.set_position(to)
		portal_lock = true




func _on_portal_1_body_entered(body):
	if body is Player:
		teleport(body, p2_pos)


func _on_portal_1_body_exited(body):
	portal_lock = false


func _on_portal_2_body_entered(body):
	if body is Player:
		teleport(body, p1_pos)


func _on_portal_2_body_exited(body):
	portal_lock = false
