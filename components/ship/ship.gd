extends CharacterBody2D

var Bullet = load("res://components/bullet/bullet.tscn")
var Explosion = load("res://components/explosion/explosion.tscn")

@export var game: Node2D = null
@export var planet: StaticBody2D = null
@export var fire_cooldown: float = 0.5
@export var SPEED = 10

######################################
@onready var visual = $Visual

######################################
var ship_velocity = Vector2(40, 0)
var applies_gravity = false
var gravity_force = 0
var gravity_vector = Vector2(0,0)
var gravity_angle = 0
var dead = false

var equipment = {
	shield = false,
}

func _ready():
	assert(game)
	assert(planet)
	assert(visual)
	
	set_physics_process(true)
	
func _physics_process(delta):
	if game.paused:
		return
		
	if !applies_gravity:
		if abs(position.x - planet.position.x) < 10:
			applies_gravity = true
	else:
		gravity_angle = position.angle_to_point(planet.position)
		gravity_force = planet.MASS / position.distance_squared_to(planet.position)
		gravity_vector = Vector2(cos(gravity_angle), sin(gravity_angle))
		ship_velocity += gravity_vector * gravity_force
		
	shield_controls(delta)
	rotation_controls(delta)
	engine_controls(delta)
	fire_controls(delta)
	deploy_controls(delta)

	move_and_collide(ship_velocity * SPEED * delta)

func rotation_controls(delta):
	if Input.is_action_pressed("ui_left"):
		rotation -= 2 * PI * delta

	if Input.is_action_pressed("ui_right"):
		rotation += 2 * PI * delta
	
func engine_controls(delta):
	if Input.is_action_just_pressed("ui_accept"):
		start_engine()
		
	if Input.is_action_just_released("ui_accept"):
		stop_engine()
	
	if Input.is_action_pressed("ui_accept"):
		engine_force(delta)
	
func fire_controls(delta):
	if Input.is_action_just_pressed("ui_down"):
		fire()
	
func engine_force(delta):
	pass
	
func deploy_controls(delta):
	if Input.is_action_just_pressed("deploy"):
		if has_node("Miner"):
			$Miner.deploy(planet, game)
	
func shield_controls(delta):
	if !equipment.shield:
		return
		
	#if Input.is_action_just_pressed("ui_up") and shield_power > 0:
	#	raise_shield()

	#if Input.is_action_just_released("ui_up"):
	#	lower_shield()


		
func start_engine():
	visual.animation = "flying"
	
func stop_engine():
	visual.animation = "hovering"
	
func fire():
	if !dead:
		var bullet = Bullet.instantiate()
		game.get_node("Bullets").add_child(bullet)
		bullet.position = position - Vector2(cos(rotation + PI/2), sin(rotation + PI/2)) * 40
		bullet.fire(Vector2(cos(rotation + PI/2), sin(rotation + PI/2)))

func explode():
	dead = true
	var explosion = Explosion.instantiate()
	game.add_child(explosion)
	game.shake_camera()
	explosion.position = position
	explosion.explode()
	queue_free()
	
	
