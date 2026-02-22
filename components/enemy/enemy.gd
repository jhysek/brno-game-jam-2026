extends Area2D

@onready var radar_animation = $Radar/AnimationPlayer
@onready var game: Node2D = null
@onready var ATTACK_COOLDOWN = 0.5

@export var enemy_type = 0

var Bullet = load("res://components/bullet/bullet.tscn")
var Explosion = load("res://components/explosion/explosion.tscn")

const TYPES = [
	{ texture = "enemy01.png" },
	{ texture = "enemy03.png" }
]


enum State {
	SCANNING,
	AIMING,
	ATTACKING,
	DEAD
}

var state = State.SCANNING
var target = null
var attack_cooldown = 0


func _ready():
	if !game:
		game = get_node("/root/PlanetScene")
	set_texture()


func _on_radar_body_entered(body: Node2D) -> void:
	if body.is_in_group("EnemyTarget"):
		state = State.AIMING
		target = body

func _on_timer_timeout() -> void:
	pass
	#if state == State.SCANNING:
	#	radar_animation.play("pulse")

func _physics_process(delta: float) -> void:
	$Radar/Visual.rotate(-delta * 5)
	
	if target:
		var old = rotation
		look_at(target.global_position)
		rotation += PI/2	
		var new = rotation
		
		rotation = lerp(old, new, delta * 3)
		
		if abs(new - old) < 0.1:
			state = State.ATTACKING
		
	if state == State.ATTACKING:
		if attack_cooldown <= 0:
			fire()
			attack_cooldown = ATTACK_COOLDOWN
		else:
			attack_cooldown -= delta
			
	
func fire():
	if state == State.ATTACKING and target:
		var bullet = Bullet.instantiate()
		bullet.speed = 20
		game.get_node("Bullets").add_child(bullet)
		bullet.global_position = $FireOrigin.global_position
		#bullet.fire(Vector2(cos(rotation - PI), sin(rotation - PI)))
		bullet.fire(-global_position.direction_to(target.global_position))

func set_texture():
	if enemy_type >= 0 and enemy_type < TYPES.size():
		$Visual.texture = load("res://components/enemy/" + TYPES[enemy_type].texture)	
	
func explode():
	state = State.DEAD 
	
	var explosion = Explosion.instantiate()
	game.add_child(explosion)
	game.enemy_shake_camera()
	explosion.position = global_position
	explosion.explode()
	hide()
	$ResetStateTimer.start()

func _on_radar_body_exited(body: Node2D) -> void:
	$ResetStateTimer.start()

func _on_reset_state_timer_timeout() -> void:
	if state == State.DEAD:
		queue_free()
		return
		
	target = null
	state = State.SCANNING
