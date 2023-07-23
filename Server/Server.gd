extends Node2D

const playerObjs = [preload("res://Player/BluePlayer.tscn"), preload("res://Player/RedPlayer.tscn"), 
preload("res://Player/GreenPlayer.tscn"), preload("res://Player/YellowPlayer.tscn")]
const level1 = preload("res://Level/level_1.tscn")
@onready var level = $Level.get_child(0)
var players_connected = 0
var next_character_spawn = 0
var player_ids = {}


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
		multiplayer.peer_disconnected.connect(self.destroy_player)
		
		peer.create_client("localhost", 4242)
		print("Client Connected")
	
	multiplayer.set_multiplayer_peer(peer)	
	
func create_player(id):	
	if players_connected <= 4:
		var player = playerObjs[next_character_spawn].instantiate()
		player.name = str(id)
		$Players.add_child(player)
		
		player_ids[id] = next_character_spawn
		next_character_spawn += 1
		players_connected += 1

		print("Player with id " + player.name)
	
func destroy_player(id):
	next_character_spawn = player_ids[id]
	print("Player " + str(id) + " disconnected.")
	player_ids.erase(id)
	players_connected -= 1

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

