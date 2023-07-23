extends Area2D
@export var next_level: String = ""
@export var number_of_players_required = 2
@onready var sprite = $AnimatedSprite2D
@onready var label = $Label

var goal_num = number_of_players_required
var players_in_zone = 0

func _ready():
	goal_num = number_of_players_required
	label.text = str(goal_num)
	
	if multiplayer.is_server():
		$Network.goal_number = goal_num
		
func _process(delta):
	if not multiplayer.is_server():
		goal_num = $Network.goal_number
		label.text = str(goal_num)
		
		if $Network.goal_animation == "Reached" and sprite.get_animation() != "Reached":
			sprite.play("Reached")
			await get_tree().create_timer(1).timeout
			
			Transitions.play_exit()
			Events.emit_signal("goal_reached")
			
		
func _on_body_entered(body):
	if body is Player:
		if multiplayer.is_server():
			players_in_zone += 1
			goal_num = number_of_players_required - players_in_zone
			label.text = str(goal_num)
			$Network.goal_number = goal_num
			
			if sprite.get_animation() != "Reached" and goal_num <= 0:
				sprite.play("Reached")
				$Network.goal_animation = "Reached"
				await get_tree().create_timer(1).timeout
				Events.emit_signal("goal_reached")
			
	

func _on_body_exited(body):
	if body is Player:
		if multiplayer.is_server():
			players_in_zone -= 1
			goal_num = number_of_players_required - players_in_zone
			label.text = str(goal_num)
			
			$Network.goal_number = goal_num
