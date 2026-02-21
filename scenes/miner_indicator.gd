extends Node2D

func init():
	update(GameState.equipment.deploys)
	
func update(number):
	var idx = 0
	for child in get_children():
		if idx < number:
			child.show()
		else:
			child.hide()
		idx += 1
		
