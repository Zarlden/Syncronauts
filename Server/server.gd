extends Object
const playerObj = preload("res://Player/BluePlayer.tscn")

func _enter_tree():
	#if "--server" in OS.get_cmdline_args():
	pass

		
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
	
	

	
