extends Node2D

const playerObj = preload("res://Player/player.tscn")
const level1 = preload("res://Level/level_1.tscn")
@onready var level = $Level_1

func _enter_tree():
	#Events.goal_reached.connect(level_transition)
	if "--server" in OS.get_cmdline_args():
		start_network(true)
	else:
		start_network(false)
	
		
func start_network(isServer):
	var peer = ENetMultiplayerPeer.new()
	if isServer:
		multiplayer.peer_connected.connect(self.create_player)
		multiplayer.peer_disconnected.connect(self.destroy_player)

		peer.create_server(4242)
		print('server listening on localhost 4242')
	else:
		multiplayer.connected_to_server.connect(self.success)
		multiplayer.connection_failed.connect(self.failed)
		
		peer.create_client("localhost", 4242)
		print("Client Connected")
	
	multiplayer.set_multiplayer_peer(peer)	
	
func create_player(id):	
	var player = playerObj.instantiate()
	player.name = str(id)
	player.position = level.respawn_location
	$Players.add_child(player)
	
	print("Player with id " + player.name)
	
func destroy_player(id):
	$Players.get_node(str(id)).queue_free()

func failed():
	print("Connection Failed")

func success():
	print("Connection Successful")

"""
func level_transition(level_number):
	
	var new_level = level1.instantiate()
	add_child(new_level)
	move_child(new_level, level.get_index())
	remove_child(level)
	call_deferred("free")
"""

