extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(self._start_game)

func _start_game():
	get_tree().change_scene_to_file("res://Level/level_1.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
