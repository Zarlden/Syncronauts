extends CharacterBody2D
class_name Player

const SPEED = 200.0
const JUMP_VELOCITY = -225.0
var colour = null

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
