extends Node2D

var paused = false

@onready var cam = $Camera2D
@onready var bg = $Bg
@onready var UI = $UI

func _ready():
	Transition.openScene()

func _process(delta):
	bg.rotation += delta * 0.04
	
func shake_camera():
	cam.shake(1, 30, 30)	
	
func enemy_shake_camera():
	cam.shake(0.5, 30, 10)	

func update_resources(type):
	UI.update_resources(type)

func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_R):
		Transition.switchTo("res://scenes/planet.tscn")
