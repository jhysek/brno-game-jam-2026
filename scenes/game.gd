extends Node2D

var paused = false

@onready var cam = $Camera2D

func _ready():
	Transition.openScene()

func shake_camera():
	cam.shake(1, 30, 30)	
	
func enemy_shake_camera():
	cam.shake(0.5, 30, 10)	
	
func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_R):
		Transition.switchTo("res://scenes/planet.tscn")
