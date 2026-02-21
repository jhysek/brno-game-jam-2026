extends Sprite2D

@export var resource_type = "crystal"
@export var rotation_offset = PI

const RESOURCES = {
	crystal = "resource01.png",
	gas = "resource02.png",
	iron = "resource03.png"
}

func _ready():
	rotation += rotation_offset
	load_resource_texture()
	$Area2D.resource_type = resource_type

func load_resource_texture():
	print("LOADING: " + "res://components/resource/" + RESOURCES[resource_type])
	texture = load("res://components/resource/" + RESOURCES[resource_type])
