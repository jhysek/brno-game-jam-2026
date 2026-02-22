extends Area2D

signal on_resource_landed

@export var SPEED = 50

var target = null
var Explosion = load("res://components/explosion/explosion.tscn")
var deployed = false

@onready var game 
var planet

var on_resource = false
var resource_type = ""

enum State {
	ATTACHED,
	DETACHED,
	DEPLOYING,
	DEPLOYED,
	DESTROYED
}

var state = State.ATTACHED
	
func deploy(_planet, _game):
	planet = _planet
	target = planet.global_position

	game = _game
	var pos = global_position
	get_parent().remove_child(self)
	game.add_child(self)
	global_position = pos
	state = State.DETACHED
	
	
func _physics_process(delta: float) -> void:
	if state == State.ATTACHED or state == State.DESTROYED or state == State.DEPLOYED:
		return
		
	if state == State.DEPLOYING:
		position = position + position.direction_to(target) * delta * SPEED
		SPEED *= 1.1
		
	if state == State.DETACHED:
		rotate(get_angle_to(target) - PI / 2)
		state = State.DEPLOYING
		
		#var angle_diff = get_angle_to(target) - PI / 2
		#rotation = lerp(rotation, rotation + angle_diff, delta * 2)
		
		#if angle_diff < 0.01:
		#	state = State.DEPLOYING
			
	
	
func _on_area_entered(area: Area2D) -> void:
	if state == State.ATTACHED or state == State.DEPLOYED:
		return
		
	if area.is_in_group("killable") and !area.is_in_group("player"):
		print(area)
		area.explode()
		explode()


func explode():
	if state == State.ATTACHED or state == State.DESTROYED:
		return
		
	state = State.DESTROYED
	var explosion = Explosion.instantiate()
	game.add_child(explosion)
	explosion.position = position
	explosion.explode()
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if state == State.DEPLOYED:
		return
		
	if body.is_in_group("Planet"):
		state = State.DEPLOYED
		var pos = global_position
		$AnimatedSprite2D.play("landed")
		get_parent().remove_child(self)
		planet.get_node("Visual/Planet").add_child(self)
		global_position = pos
		rotate(get_angle_to(target) - PI / 2)
		
		check_resources()
		
		
func check_resources():
	for area in get_overlapping_areas():
		if area.is_in_group("resource"):
			on_resource = true
			resource_type = area.resource_type
			GameState.resources[resource_type] += 1
			game.update_resources(resource_type)
			emit_signal("on_resource_landed")
			
	if !on_resource:
		explode()
