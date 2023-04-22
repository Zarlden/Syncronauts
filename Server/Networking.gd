extends Node2D

var sync_position: Vector2:
	set(value):
		sync_position = value
		is_processed = false
var sync_velocity: Vector2
var sync_direction: float
var is_processed = false
