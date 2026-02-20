extends StaticBody2D

@export var MASS = 20_000
@export var ROTATION = 0.25 * PI

@onready var planet = $Visual/Planet

func _ready():
	randomize()
	set_process(true)
	

func configure(idx):
	assert(PlanetDefinitions.PLANETS.has(idx), "NO PLANET DEFINITION FOR IDX: " + str(idx))
	
	var conf = PlanetDefinitions.PLANETS.has(idx)
	
	if conf.has("rotation"):
		ROTATION = conf.rotation
		
	
func randomize():
	ROTATION = randf() * 0.25 * PI - 0.5 * PI
	for resource in $Visual/Resources.get_children():
		resource.rotate(randf() * 2 * PI)
		
		
func _process(delta):
	planet.rotation += delta * ROTATION
