extends CharacterBody2D



var Bullet = load("res://components/bullet/bullet.tscn")
var Explosion = load("res://components/explosion/explosion.tscn")
var Miner = load("res://components/miner/miner.tscn")

var ShieldL1 = load("res://components/shield/lvl_1.tscn")
var ShieldL2 = load("res://components/shield/shield_l2.tscn")

@export var game: Node2D = null
@export var planet: StaticBody2D = null
@export var fire_cooldown: float = 0.5
@export var SPEED = 8

######################################
@onready var visual = $Visual
var shield

######################################
var ship_velocity = Vector2(40, 0)
var applies_gravity = false
var gravity_force = 0
var gravity_vector = Vector2(0,0)
var gravity_angle = 0

var remaining_deploys = GameState.equipment.miners
var ammo = GameState.equipment.ammo
var miners_placed = 0

enum State {
	WAITING,
	FLYING,
	DEAD
}

var state = State.WAITING

var dead = false
var waiting = true

var equipment = {
	shield = false,
}

func _ready():
	assert(game)
	assert(planet)
	assert(visual)
	
	if GameState.equipment.shield == 1:
		var shield1 = ShieldL1.instantiate()
		get_node("Shield").add_child(shield1)
		
	if GameState.equipment.shield > 1:
		shield = ShieldL2.instantiate()
		shield.init(GameState.equipment.shield)
		shield.energy_changed.connect(func(remains): 
			print("REMAINING SHIELD: " + str(remains) + "s")
		)
		get_node("Shield").add_child(shield)
		
	set_physics_process(true)
	
func _physics_process(delta):
	if state == State.WAITING:
		if Input.is_action_just_pressed("ui_accept"):
			state = State.FLYING
		return
		
	if game.paused or state == State.DEAD:
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
	if remaining_deploys <= 0:
		return
		
	if Input.is_action_just_pressed("deploy"):
		remaining_deploys -= 1
		game.update_mine_indicators(remaining_deploys)
		var miner = Miner.instantiate()
		game.add_child(miner)
		miner.position = global_position
		miner.deploy(planet, game)
		miner.on_resource_landed.connect(func(): miners_placed += 1)
		
		if remaining_deploys <= 0:
			if miners_placed > 0:
				game.mission_successful()
			else:
				game.mission_failed()
			$ExitTimer.start()


func shield_controls(delta):
	if GameState.equipment.shield <= 1:
		return
		
	if Input.is_action_just_pressed("ui_up"):
		shield.turn_on()

	if Input.is_action_just_released("ui_up"):
		shield.turn_off()

func start_engine():
	visual.animation = "flying"
	
func stop_engine():
	visual.animation = "flying"
	
func fire():
	if state == State.FLYING:
		if ammo <= 0:
			$Sfx/NoAmmo.play()
			return
			
		var bullet = Bullet.instantiate()
		game.get_node("Bullets").add_child(bullet)
		bullet.position = $FireOrigin.global_position
		bullet.fire(Vector2(cos(rotation + PI/2), sin(rotation + PI/2)))
		ammo -= 1
		# TODO: update ammo indicator

func explode():
	state = State.DEAD
	var explosion = Explosion.instantiate()
	game.add_child(explosion)
	game.player_killed()
	explosion.position = position
	explosion.explode()
	queue_free()
	

func _on_timer_timeout() -> void:
	Transition.switchTo("res://scenes/garage.tscn")
