extends PathFollow2D

@export var speed = 100.0

func _ready():
	set_process(true)

func _process(delta):
	unit_offset += (speed * delta) / curve.get_length()
	if unit_offset > 1.0:
		unit_offset = 0
