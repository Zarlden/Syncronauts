extends Path2D

@onready var animation_player = $AnimationPlayer
@onready var platform = $Platform

var moving = false
var requirement_to_move = 1 #number of players required to move
var label = null
var temp = 0
var bumped_players = 0
var paused = true

# Called when the node enters the scene tree for the first time.
func _ready():
	label = platform.get_node("Label")
	label.text = str(requirement_to_move)
	platform.get_node("Upper").body_entered.connect(onPlatformEntered)
	platform.get_node("Upper").body_exited.connect(onPlatformExit)
	platform.get_node("Lower").body_entered.connect(onLowerEntered)
	platform.get_node("Lower").body_exited.connect(onLowerExited)

func onPlatformEntered(body):
	if body is Player:
		requirement_to_move -= 1
		label.text = str(requirement_to_move)
		print("Enter", requirement_to_move)

			
func onPlatformExit(body):
	if body is Player:
		requirement_to_move += 1
		label.text = str(requirement_to_move)
		print("Exit", requirement_to_move)

func onLowerEntered(body):
	if body is Player:
		bumped_players += 1

func onLowerExited(body):
	if body is Player:
		bumped_players -= 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if bumped_players != 0 :
		animation_player.pause()
		paused = true
	
	if paused and bumped_players ==0:
		paused = false
		animation_player.play_backwards("leftToRight")
		moving = false
		
	if requirement_to_move <= 0 and not moving:
		animation_player.play("leftToRight")
		moving = true
	elif requirement_to_move > 0 and moving:
		animation_player.play_backwards("leftToRight")
		moving = false
