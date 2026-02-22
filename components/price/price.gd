extends Node2D

@export var crystal = 0
@export var gas = 0
@export var iron = 0


func _ready():
	update(crystal, gas, iron)
	
func update(c, g, i):
	crystal = clamp(c, 0, 99)
	gas = clamp(g, 0, 99)
	iron = clamp(i, 0, 99)
	
	$crystal.text = str(crystal)
	$gas.text = str(gas)
	$iron.text = str(iron)
