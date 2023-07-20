extends Node2D
class_name Barrier

@onready var camera = $Camera2D
@onready var spawn = $SpawnPosition

var respawn_location = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	Events.player_dead.connect(respawn)
	Events.checkpoint_reached.connect(checkpoint)
	#new_player.connect_camera(camera)
	if multiplayer.is_server():
		$Network.respawn_location = spawn.position
		
	camera.set_zoom(Vector2(0.3, 0.3))
	print("Respawn Loc is " + str(respawn_location.x) + " " + str(respawn_location.y))
	print(camera.is_current())
	print(camera.get_zoom())
	
func respawn(id):
	var player = get_tree().get_root().get_node("Server").get_node("Players").get_node(str(id))
	player.position = respawn_location
	
func checkpoint(location):
	respawn_location = location
	if multiplayer.is_server():
		$Network.respawn_location = respawn_location
		

func _on_multiplayer_synchronizer_synchronized():
	if respawn_location != $Network.respawn_location:
		respawn_location = $Network.respawn_location
