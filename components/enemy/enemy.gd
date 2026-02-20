extends Area2D

@onready var radar_animation = $Radar/AnimationPlayer

func _on_radar_body_entered(body: Node2D) -> void:
	if body.is_in_group("EnemyTarget"):
		print("DETECTED")

func _on_timer_timeout() -> void:
	radar_animation.play("pulse")
