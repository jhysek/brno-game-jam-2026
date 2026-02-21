extends Area2D

var gravity_force = 0
var gravity_vector = Vector2(0,0)
var gravity_angle = 0

var velocity = Vector2(0,0)
var speed = 20

var fired = false

@onready var planet = get_node("/root/PlanetScene/Planet")
@onready var game   = get_node("/root/PlanetScene")

func fire(direction_vec):
	print("FIRE (exclamation mark)")
	velocity = direction_vec * speed
	fired = true
	$Sfx/Fire.play()
	set_physics_process(true)

func _physics_process(delta):
	if !game:
		return
	
	if !game.paused and fired:
		gravity_angle = position.angle_to_point(planet.position)
		gravity_force = planet.MASS / global_position.distance_squared_to(planet.position)
		gravity_vector = Vector2(cos(gravity_angle), sin(gravity_angle))
		velocity -= gravity_vector * gravity_force
		rotation = gravity_angle - PI / 2

		position -= (velocity * speed * delta)

		if position.x > 1000 or position.x < -1000 or position.y > 1000 or position.y < -1000:
			queue_free()


func _on_body_entered(body: Node2D) -> void:
	print("BODY HIT: " + str(body))

	queue_free()
	if body.is_in_group("killable"):
		body.explode()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("killable"):
		print("AREA HIT")
		area.explode()
		queue_free()
