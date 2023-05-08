extends Control

@export var levels = 1
var level_to_load = "res://Level/level_%d.tscn"

func _start_game():
	var level_idx = $LevelSelectList.get_selected_items()[0]
	get_tree().change_scene_to_file(level_to_load % (level_idx + 1))

func _close_game():
	get_tree().quit()

# Called when the node enters the scene tree for the first time.
func _ready():
	$StartButton.pressed.connect(self._start_game)
	$ExitButton.pressed.connect(self._close_game)
	_init_item_list()

func _init_item_list():
	for i in range(levels):
		$LevelSelectList.add_item("Level %d" % (i + 1))
		
		
# Check if the exit key is pressed then bring up the menu
func _process(delta):
	if Input.is_action_pressed("Exit"):
		print("s")
		var scene_trs = load("res://UI/main_menu.tscn")
		var scene = scene_trs.instance()
		add_child(scene)

