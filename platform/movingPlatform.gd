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

# Called when the node enters the scene tree for the first time.
func _ready():
	label = platform.get_node("Label")
	platform.get_node("PlayerDetectArea").body_entered.connect(enter_platform)
	platform.get_node("PlayerDetectArea").body_exited.connect(exit_platform)
	
	label.text = str(requirement_to_move)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var total_weights = abs(platformCounter) - 1 #-1 is no players, -2 is 1 player etc..
	
	requirement_to_move = max(requirement_to_move - total_weights, 0)
	label.text = str(requirement_to_move)
	if requirement_to_move <= 0 and not moving:
		animation_player.play("leftToRight")
		moving = true
	elif requirement_to_move > 0 and moving:
		animation_player.play_backwards("leftToRight")
		moving = false
	requirement_to_move = required_weight

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
		
