extends AnimatableBody2D

signal pressure_plate_pressed
signal pressure_plate_released

var hasTriggered = false
var red_button = null

func _on_area_2d_body_entered(body):
	if body is Player and not hasTriggered:
		print("Entered")
		red_button = $PressurePlateButton
		remove_child($PressurePlateButton)
		emit_signal("pressure_plate_pressed")
		hasTriggered = true


func _on_area_2d_body_exited(body):
	if body is Player and hasTriggered:
		add_child(red_button)
		emit_signal("pressure_plate_released")
		hasTriggered = false
