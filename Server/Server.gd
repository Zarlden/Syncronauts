extends Node2D

const playerObjs = [preload("res://Player/BluePlayer.tscn"), preload("res://Player/RedPlayer.tscn"), 
preload("res://Player/GreenPlayer.tscn"), preload("res://Player/YellowPlayer.tscn")]
const levels = [preload("res://Level/level_1.tscn"), preload("res://Level/level_2.tscn")]
var players_connected = 0
var next_character_spawn = 0
var player_ids = {}
var level_index = 0

@onready var players = $Players


func _enter_tree():
	Events.goal_reached.connect(level_transition)
	level_transition()
	
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


func level_transition():
	
	print(multiplayer.is_server())
	
	if multiplayer.is_server() and level_index < levels.size(): #messy, its too late at night
		change_scene(levels[level_index])
		level_index += 1
		
	elif not multiplayer.is_server():
		await get_tree().create_timer(0.2).timeout
		
		for player in players.get_children():
			player.player_died()
		
		change_scene(levels[level_index])
	
func change_scene(scene: PackedScene):
	
	var level_manager = $Level_Manager
	
	if multiplayer.is_server():
		for level in level_manager.get_children():
			level_manager.call_deferred("remove_child", level)
			level.call_deferred("queue_free")
		
		level_manager.add_child(scene.instantiate(), true)
		return
		
	if level_manager.get_children().size() > 0:
		var removed_level = level_manager.get_children()[0]
		print(removed_level.name)
		level_manager.call_deferred("remove_child", removed_level)
		removed_level.call_deferred("queue_free")
