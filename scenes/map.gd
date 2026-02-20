extends Node2D

@onready var bg = $Bg

func _ready():
	set_process(true)
	
func _process(delta):
	bg.rotation += delta * 0.01
