extends Sprite2D

var tween: Tween = null

func _ready():
	update_resources(null)

func update_resources(type):
	$crystal.text = str(GameState.resources.crystal)
	$gas.text = str(GameState.resources.gas)
	$iron.text = str(GameState.resources.iron)
	

func pulse(obj) -> void:
	if tween:
		tween.kill()
		obj.scale = Vector2.ONE  # reset in case it was mid-animation

	tween = create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(obj, "scale", Vector2(1.3, 1.3), 0.15)
	tween.tween_property(obj, "scale", Vector2.ONE, 0.3)
