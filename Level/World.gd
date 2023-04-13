extends Node2D

const playerObj = preload("res://Player/player.tscn")

@onready var camera = $Camera2D
@onready var new_player = $Player

var respawn_location = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	Events.player_dead.connect(respawn)
	Events.checkpoint_reached.connect(checkpoint)
	new_player.connect_camera(camera)
	respawn_location = new_player.global_position
	
func respawn():
	var player = playerObj.instantiate()
	add_child(player)
	player.position = respawn_location
	player.connect_camera(camera)
	
func checkpoint(location):
	respawn_location = location
	
	
