extends Path2D

@onready var animation_player = $AnimationPlayer
@onready var platform = $Platform

var moving = false
var requirement_to_move = 1 #number of players required to move
var label = null

# Called when the node enters the scene tree for the first time.
func _ready():
	print(platform)
	label = platform.get_node("Label")
	label.text = str(requirement_to_move)
	platform.get_node("Area2D").body_entered.connect(onPlatformEntered)
	platform.get_node("Area2D").body_exited.connect(onPlatfromExit)

func onPlatformEntered(body):
	if body is Player:
		requirement_to_move -= 1
		label.text = str(requirement_to_move)
		print("Enter", requirement_to_move)

			
func onPlatfromExit(body):
	if body is Player:
		requirement_to_move += 1
		label.text = str(requirement_to_move)
		print("Exit", requirement_to_move)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if requirement_to_move <= 0 and not moving:
		animation_player.play("leftToRight")
		moving = true
	elif requirement_to_move > 0 and moving:
		animation_player.play_backwards("leftToRight")
		moving = false
