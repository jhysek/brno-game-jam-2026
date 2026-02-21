extends Node2D

func _ready():
	Transition.openScene()

func _on_button_pressed() -> void:
	Transition.switchTo("res://scenes/map.tscn")

func _process(delta):
	$Bg.rotation += delta * 0.06
