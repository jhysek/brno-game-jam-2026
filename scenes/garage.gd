extends Node2D

func _ready():
	Transition.openScene()
	hide_panels()
	
func _on_button_pressed() -> void:
	Transition.switchTo("res://scenes/map.tscn")

func _process(delta):
	$Bg.rotation += delta * 0.06
	
func update_resource_indicator():
	$UI.update_resources("?")

func _on_ammo_upgrade_pressed() -> void:
	var current_level = GameState.upgrades.ammo.level
	if current_level == GameState.upgrades.ammo.levels.size() - 1:
		print("MAX LEVEL")
		return
		
	var upgrade_price = GameState.upgrades.ammo.levels[current_level + 1].price
	if has_resources(upgrade_price):
		pay_price(upgrade_price)
		update_resource_indicator()
		GameState.upgrades.ammo.level += 1
		update_indicator_position($Mothership/Bg/Veins/Upgrade1/Panel/Indicator, GameState.upgrades.ammo.level)
	
	
func update_indicator_position(obj, level):
	obj.position = Vector2(0, 29 + level * 23)
	
func _on_ammo_downgrade_pressed() -> void:
	var current_level = GameState.upgrades.ammo.level
	if current_level <= 0:
		print("MIN LEVEL")
		return
		
	var current_level_price = GameState.upgrades.ammo.levels[current_level].price
	earn_price(current_level_price)
	update_resource_indicator()
	GameState.upgrades.ammo.level -= 1
	update_indicator_position($Mothership/Bg/Veins/Upgrade1/Panel/Indicator, GameState.upgrades.ammo.level)
	
	
func hide_panels():
	for node in get_tree().get_nodes_in_group("UpgradePanel"):
		node.get_node("../Light").enabled = false
		node.hide()

func has_resources(price):
	var resources = GameState.resources
	for resource_name in price:
		var resource_amount = price[resource_name]
		if resources[resource_name] < resource_amount:
			return false
	return true

func pay_price(price):
	for resource_name in price:
		var resource_amount = price[resource_name]
		GameState.resources[resource_name] -= resource_amount
		
func earn_price(price):
	for resource_name in price:
		var resource_amount = price[resource_name]
		GameState.resources[resource_name] += resource_amount

func _on_up_1_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		hide_panels()
		$Mothership/Bg/Veins/Upgrade1/Panel.show()
		$Mothership/Bg/Veins/Upgrade1/Light.enabled = true
		
func _on_up_2_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		hide_panels()
		$Mothership/Bg/Veins/Upgrade2/Panel.show()
		$Mothership/Bg/Veins/Upgrade2/Light.enabled = true
		
func _on_up_3_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		hide_panels()
		$Mothership/Bg/Veins/Upgrade3/Panel.show()
		$Mothership/Bg/Veins/Upgrade3/Light.enabled = true
		
func _on_up_4_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		hide_panels()
		$Mothership/Bg/Veins/Upgrade4/Panel.show()
		$Mothership/Bg/Veins/Upgrade4/Light.enabled = true
		
