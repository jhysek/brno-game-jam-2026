extends Label

func write(msg_text):
	text = msg_text
	$AnimationPlayer.play("appear")
