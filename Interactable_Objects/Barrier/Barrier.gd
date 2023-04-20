extends Area2D

func _on_body_entered(body):
	if body is Player:
		if body.colour != Barrier.COLOR:
			$BarrierShape/CollisionShape2D.set_deferred("disabled", true)
