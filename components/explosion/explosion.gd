extends Node2D

func explode():
	$AnimationPlayer.play("explode")
	$Sfx/Explode.play()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
