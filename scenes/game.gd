extends Node2D

var paused = false

@onready var cam = $Camera2D

func shake_camera():
	cam.shake(1, 30, 30)	
	
