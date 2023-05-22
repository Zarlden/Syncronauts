extends CharacterBody2D
class_name Player

const SPEED = 200.0
const JUMP_VELOCITY = -275.0
const colourNode = preload("res://ColourNode.gd")
var colour = colourNode.colourSet.BLUE
var weight = 1
var starting_weight = weight

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animate_sprite = $AnimatedSprite2D
@onready var player_transform = $RemoteTransform2D

func is_local_authority():
	return $Networking/MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id()

func _ready():
	colour = $ColourNode.colour
	$Networking/MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	print(colour)
	
	if is_local_authority():
		$Camera2D.make_current()


	

func _physics_process(delta):
	if not is_local_authority():
		if not $Networking.is_processed:
			position = $Networking.sync_position
			$Networking.is_processed = true
		velocity = $Networking.sync_velocity
		var direction = $Networking.sync_direction
		
		if not is_on_floor(): 
			animate_sprite.animation = "jump"
		else:
			if(velocity.x == 0):
				animate_sprite.animation = "idle"
			else:
				animate_sprite.animation = "run"
		
		if direction:
			if(velocity.x > 0):
				animate_sprite.flip_h = false
			else:
				animate_sprite.flip_h = true	
		
		move_and_slide()
		return
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
	$Networking.sync_position = position
	$Networking.sync_velocity = velocity
	$Networking.sync_direction = direction
	$Networking.is_processed = false
	
func player_died():
	Events.emit_signal("player_dead", name)

func connect_camera(camera):
	var camera_path = camera.get_path()
	player_transform.remote_path = camera_path


func _on_top_player_body_entered(body):
	if body is Player and body != self:
		weight += 1
		emit_signal("weight_updated")

func _on_top_player_body_exited(body):
	if body is Player and body != self:
		weight -= 1
		emit_signal("weight_updated")

func _process(delta):
	weight = update_weight()

# Check the above player by calling their update weight function
func update_weight(current_weight = 1):
	var max_weight = current_weight

	for body in $TopPlayer.get_overlapping_bodies():
		if body == self:
			continue

		if body is Player:
			var weight = body.update_weight(current_weight + 1)
			if weight > max_weight:
				max_weight = weight

	return max_weight

