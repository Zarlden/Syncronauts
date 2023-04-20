extends Node2D

const playerObj = preload("res://Player/player.tscn")

@onready var camera = $Camera2D
@onready var new_player = $Player

var respawn_location = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	Events.player_dead.connect(respawn)
	Events.checkpoint_reached.connect(checkpoint)
	#new_player.connect_camera(camera)
	respawn_location = new_player.global_position
	
func respawn():
	var player = playerObj.instantiate()
	add_child(player)
	player.position = respawn_location
	player.connect_camera(camera)
	
func checkpoint(location):
	respawn_location = location
	
func _enter_tree():
	if "--server" in OS.get_cmdline_args():
		start_network(true)
	else:
		start_network(false)
	
		
func start_network(isServer):
	var peer = ENetMultiplayerPeer.new()
	if isServer:
		multiplayer.peer_connected.connect(create_player)
		multiplayer.peer_disconnected.connect(destroy_player)
		peer.create_server(8080)
	else:
		peer.create_client("localhost", 8080)
	
func create_player(id):
	var player = playerObj.instantiate()
	$Players.add_child(player)
	player.name = str(id)
	
func destroy_player(id):
	$Players.get_node(str(id)).queue_free()
	
	

	

	
