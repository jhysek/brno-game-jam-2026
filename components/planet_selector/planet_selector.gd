extends Area2D

@onready var visual = $Visual

func _on_mouse_entered() -> void:
	hover()
	
func _on_mouse_exited() -> void:
	unhover()

func hover():
	print("HOVERED")

func unhover():
	print("UN-HOVERED")

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		print("CLICKED")
