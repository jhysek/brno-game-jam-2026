extends StaticBody2D

@export var MASS = 20_000
@export var ROTATION = 0.25 * PI
@export var entangled: Node2D = null
@export var entangled_nodes: Array[Node2D] = []
@export var entangled_multipliers: Array[float] = []

@onready var planet = $Visual/Planet



func _ready():
	initialize_planet()
	set_process(true)
	
func initialize_planet():
	var config = GameState.currrent_planet 
	planet.get_node("Bg").texture = load("res://components/planet/" + config.texture)
	ROTATION = config.rotation

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
	var idx = 0
	for entangled in entangled_nodes:
		entangled.rotation += delta * entangled_multipliers[idx]
		idx += 1
