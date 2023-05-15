extends Path2D

@onready var animation_player = $AnimationPlayer
@onready var platform = $Platform

var moving = false
var requirement_to_move = 2 #number of players required to move
var required_weight = requirement_to_move
var label = null

# Called when the node enters the scene tree for the first time.
func _ready():
	print(platform)
	label = platform.get_node("Label")
	label.text = str(requirement_to_move)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var total_weights = 0
	for body in $Platform/PlayerDetectArea.get_overlapping_bodies():
		if body is Player:
			total_weights += body.weight
	requirement_to_move -= total_weights
	label.text = str(requirement_to_move)
	if requirement_to_move <= 0 and not moving:
		animation_player.play("leftToRight")
		moving = true
	elif requirement_to_move > 0 and moving:
		animation_player.play_backwards("leftToRight")
		moving = false
	requirement_to_move = required_weight

