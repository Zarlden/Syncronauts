extends Path2D

@onready var animation_player = $AnimationPlayer
@onready var platform = $Platform

var moving = false
@export var required_weight = 2
var requirement_to_move = required_weight #number of players required to move
var label = null
var temp = 0
var bumped_players = 0
var paused = true
var platformCounter = -1
var state = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	label = platform.get_node("Label")
	label.text = str(requirement_to_move)
	
	if multiplayer.is_server():
		platform.get_node("PlayerDetectArea").body_entered.connect(enter_platform)
		platform.get_node("PlayerDetectArea").body_exited.connect(exit_platform)
		platform.get_node("BottomDetectArea").body_entered.connect(onLowerEntered)
		platform.get_node("BottomDetectArea").body_exited.connect(onLowerExited)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if multiplayer.is_server():
		var total_weights = abs(platformCounter) - 1 #-1 is no players, -2 is 1 player etc..
		
		requirement_to_move = max(requirement_to_move - total_weights, 0)
		label.text = str(requirement_to_move)
		
		if bumped_players != 0 :
			animation_player.pause()
			paused = true
			moving = false

		if paused and bumped_players ==0:
			paused = false
			moving = true
			
		if requirement_to_move <= 0 and not moving and not paused:
			animation_player.play("leftToRight")
			moving = true

		if requirement_to_move > 0 and moving and not paused:
			animation_player.play_backwards("leftToRight")
			moving = false
			
		$Network.platform_number = requirement_to_move
		$Network.platform_position = platform.position
		$Network.platform_is_processed = false
		
		requirement_to_move = required_weight
		return
		

	label.text = str($Network.platform_number)
	if not $Network.platform_is_processed:
		platform.position = lerp(platform.position, $Network.platform_position, 0.99)
		$Network.platform_is_processed = true
	
		
	


func enter_platform(body):
	if body is Player:
		body.platform_ptr = self
		platformCounter = max(platformCounter - 1, -5)
		print("PF Counter Enter: " + str(platformCounter))
		
func exit_platform(body):
	if body is Player:
		body.platform_ptr = null
		platformCounter = min(platformCounter + 1, -1)
		print("PF Counter Exit: " + str(platformCounter))
		
func onLowerEntered(body):
	if body is Player:
		bumped_players += 1

func onLowerExited(body):
	if body is Player:
		bumped_players -= 1
