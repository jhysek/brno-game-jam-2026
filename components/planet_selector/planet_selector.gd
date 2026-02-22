extends Area2D

@onready var visual = $Visual
@export var number: int = 0

func _on_mouse_entered() -> void:
	hover()
	
func _on_mouse_exited() -> void:
	unhover()

func hover():
	print("HOVERED")

func unhover():
	print("UN-HOVERED")

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		GameState.currrent_planet = PlanetDefinitions.PLANETS[number]
		Transition.switchTo("res://scenes/planet.tscn")

func set_planet(config):
	visual.texture = load("res://components/planet/" + config.texture)
	
func _process(delta):
	visual.rotation += delta * PlanetDefinitions.PLANETS[number].rotation
