extends Node2D

signal energy_changed(current)

@onready var capacity = 5
var on = false

func _ready():
	turn_off()

func init(_capacity):
	capacity = _capacity

func hit():
	$Sfx/Hit.play()

func turn_on():
	if capacity >= 0:
		on = true
		$Visual.show()
		$ShieldArea.monitorable = true
		$ShieldArea.monitoring = true
		$ShieldArea.collision_layer = 1
	
func turn_off():
	on = false
	$Visual.hide()
	$ShieldArea.monitorable = false
	$ShieldArea.monitoring = false
	$ShieldArea.collision_layer = 2

func _physics_process(delta: float) -> void:
	if on:
		capacity -= delta
		if capacity < 0:
			capacity = 0
		emit_signal("energy_changed", capacity)
		
	if capacity <= 0:
		$Sfx/depleted.play
		turn_off()
