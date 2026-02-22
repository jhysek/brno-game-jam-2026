extends Node2D

var paused = false

@onready var cam = $Camera2D
@onready var bg = $Bg
@onready var UI = $UI

func _ready():
	$MinerIndicator.init()
	Transition.openScene()
	$Message.write("Press SPACE to start")

func _process(delta):
	bg.rotation += delta * 0.04
	
func player_killed():
	shake_camera()
	$Message.write("Mission failed! R to restart")
	
func mission_successful():
	$Message.write("Mission acomplished!")
	
func mission_failed():
	$Message.write("Mission failed!")
	
func shake_camera():
	cam.shake(1, 30, 30)	
	
func enemy_shake_camera():
	cam.shake(0.5, 30, 10)	

func update_resources(type):
	UI.update_resources(type)

func update_mine_indicators(count):
	$MinerIndicator.update(count)

func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_R):
		Transition.switchTo("res://scenes/planet.tscn")
