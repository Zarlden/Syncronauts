extends Node2D

@onready var camera = $Camera2D
@onready var spawn = $SpawnPosition

var respawn_location = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	Events.player_dead.connect(respawn)
	Events.checkpoint_reached.connect(checkpoint)
	#new_player.connect_camera(camera)
	respawn_location = spawn.position
	print(respawn_location)
	
func respawn(id):
	var player = get_tree().get_root().get_node("Server").get_node("Players").get_node(str(id))
	player.position = respawn_location
	
func checkpoint(location):
	respawn_location = location
	

	
	

	

	
