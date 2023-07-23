extends AnimatableBody2D

signal pressure_plate_pressed
signal pressure_plate_unpressed

@onready var animation_player = $AnimationPlayer
var hasTriggered = false


func _ready():
	$Area2D.body_entered.connect(pressed)

func pressed(body):
	if body is Player and not hasTriggered:
		
		animation_player.play("pressed")
		print("Entered")
		emit_signal("pressure_plate_pressed")
		hasTriggered = true
