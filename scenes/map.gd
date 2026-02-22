extends Node2D

@onready var bg = $Bg

func _ready():
	for planet in $Planets.get_children():
		planet.scale = Vector2(0.5, 0.5)
		init_planet(planet)	
	
	Transition.openScene()
	set_process(true)
	
func init_planet(obj):
	print(obj.number)
	var config = PlanetDefinitions.PLANETS[obj.number]
	obj.set_planet(config)
	
func _process(delta):
	bg.rotation -= delta * 0.02
	
	update_planet_sizes()
	
	
func update_planet_sizes():
	for planet in $Planets.get_children():
		var distance = planet.global_position.distance_to(get_global_mouse_position())
		var screen_width = get_viewport().get_visible_rect().size.x
	
		var ratio = 1 - (distance / 300)*(distance / 300)
		print(ratio)
		ratio = clamp(ratio, 0.2, 1)
		planet.scale = Vector2(ratio, ratio)
