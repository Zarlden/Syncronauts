extends Area2D

var barrier_colour = null

func _ready():
	$BarrierShape/BarrierCollision.set_deferred("disabled", false)
	barrier_colour = $ColourNode.colour
	#print(barrier_colour)

func _on_body_entered(body):
	if body is Player:	
		if body.colour == barrier_colour:
			$BarrierShape/BarrierCollision.set_deferred("disabled", true)
			return
		
	$BarrierShape/BarrierCollision.set_deferred("disabled", false)	

func _on_body_exited(body):
	if body is Player:
		$BarrierShape/BarrierCollision.set_deferred("disabled", false)

