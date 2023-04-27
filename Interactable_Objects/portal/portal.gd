extends Node2D

# Check each portal body, if a player enters, set
# their position to the other portal
var p1_pos = null
var p2_pos = null
var portal_lock = false
@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	p1_pos = $Portal1.get_position()
	p2_pos = $Portal2.get_position()


func teleport(player, to):
	if not portal_lock:
		if not portal_lock:
			player.set_position(to)
		timer.start()
		portal_lock = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Portal1.has_overlapping_bodies():
		for node in $Portal1.get_overlapping_bodies():
			if node is Player:
				teleport(node, p2_pos)
	elif $Portal2.has_overlapping_bodies():
		for node in $Portal2.get_overlapping_bodies():
			if node is Player:
				teleport(node, p1_pos)


func _on_timer_timeout():
	portal_lock = false
