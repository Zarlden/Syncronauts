extends CharacterBody2D
class_name Player

const SPEED = 200.0
const JUMP_VELOCITY = -225.0
const colourNode = preload("res://ColourNode.gd")
var colour = colourNode.colourSet.BLUE
var weight = 1
var starting_weight = weight

var player_on_top = false
var should_check_weights = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animate_sprite = $AnimatedSprite2D
@onready var player_transform = $RemoteTransform2D

func _ready():
	colour = $ColourNode.colour
	print(colour)


	

func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor(): 
		velocity.y += gravity * delta
		animate_sprite.animation = "jump"
	else:
		if(velocity.x == 0):
			animate_sprite.animation = "idle"
		else:
			animate_sprite.animation = "run"
			
	# Handle Jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
		if(velocity.x > 0):
			animate_sprite.flip_h = false
		else:
			animate_sprite.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide();
	
func player_died():
	Events.emit_signal("player_dead")
	queue_free()

func connect_camera(camera):
	var camera_path = camera.get_path()
	player_transform.remote_path = camera_path


#func _on_top_player_body_entered(body):
#	if body is Player and body != self:
#		weight += 1
#		emit_signal("weight_updated")

#func _on_top_player_body_exited(body):
#	if body is Player and body != self:
#		weight -= 1
#		emit_signal("weight_updated")

func _process(delta):
	if should_check_weights:
		var new_weight = update_weight()
		if weight == new_weight:
			return
		else:
			weight = new_weight
	#for body in $BottomPlayer.get_overlapping_bodies():
	#	if body is Platform:
	#		print("Update")
	#		weight = update_weight()

# Check the above player by calling their update weight function
func update_weight():
	for body in $TopPlayer.get_overlapping_bodies():
		if body is Player and body != self:
			var top_weight = body.update_weight()
			return top_weight + 1
	return 1



func _on_bottom_player_body_entered(body):
	if body is Platform:
		should_check_weights = true


func _on_bottom_player_body_exited(body):
	if body is Platform:
		should_check_weights = false
