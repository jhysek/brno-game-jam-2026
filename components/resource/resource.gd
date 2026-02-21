extends Sprite2D

@export var resource_type = "crystal"

const RESOURCES = {
	crystal = "resource01.png"
}

func _ready():
	load_resource_texture()
	$Area2D.resource_type = resource_type

func load_resource_texture():
	print("LOADING: " + "res://components/resource/" + RESOURCES[resource_type])
	texture = load("res://components/resource/" + RESOURCES[resource_type])
