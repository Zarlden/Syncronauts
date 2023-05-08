extends Path2D

@onready var animation_player = $AnimationPlayer
@onready var platform = $Platform

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	animation_player.play("slideToSlide")
		
		
