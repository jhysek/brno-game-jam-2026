extends CharacterBody2D

func _on_bullet_detector_area_entered(area: Area2D) -> void:
	$Shield.turn_on()

func _on_bullet_detector_area_exited(area: Area2D) -> void:
	$Shield.turn_off()
