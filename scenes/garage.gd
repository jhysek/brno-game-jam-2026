extends Node2D

const upgrade_names = ['ammo', 'shield', 'fuel', 'miners']

func _ready():
	Transition.openScene()
	hide_panels()
	update_pricelist()
	
func update_pricelist():
	var idx = 0
	for name in upgrade_names:
		var current_level = GameState.upgrades[name].level
		var levels = GameState.upgrades[name].levels
		var pricelist = $Mothership/Bg/Veins.get_node("Upgrade" + str(idx + 1) + "/Panel/Pricelist")
		$Mothership/Bg/Veins.get_node("Upgrade" + str(idx + 1) + "/Panel/Label").text = "> " + GameState.upgrades[name].label
		pricelist.text = ""
		
		var line_no = 1
		for level in levels:
			var line = "[  ]"
			if current_level >= line_no - 1:
				line = "[x]"
			
			line += " " + level.text
			line += "\n\n"
			pricelist.text += line
			
			pricelist.get_node("Price" + str(line_no)).update(level.price.crystal, level.price.gas, level.price.iron)
			line_no += 1

		idx += 1
	
func _on_button_pressed() -> void:
	Transition.switchTo("res://scenes/map.tscn")

func _process(delta):
	$Bg.rotation += delta * 0.06
	
func update_resource_indicator():
	$UI.update_resources("?")

func _on_upgrade_pressed(idx: int) -> void:	
	var current_level = GameState.upgrades[upgrade_names[idx]].level
	if current_level == GameState.upgrades[upgrade_names[idx]].levels.size() - 1:
		print("MAX LEVEL")
		return
		
	var upgrade_price = GameState.upgrades[upgrade_names[idx]].levels[current_level + 1].price
	if has_resources(upgrade_price):
		pay_price(upgrade_price)
		update_resource_indicator()
		GameState.upgrades[upgrade_names[idx]].level += 1
		GameState.equipment[upgrade_names[idx]] = GameState.upgrades[upgrade_names[idx]].levels[current_level + 1].value
		update_indicator_position($Mothership/Bg/Veins.get_node("Upgrade" + str(idx + 1) + "/Panel/Indicator"), GameState.upgrades[upgrade_names[idx]].level)
	
	
func update_indicator_position(obj, level):
	obj.position = Vector2(0, 29 + level * 23)
	
func _on_downgrade_pressed(idx: int) -> void:		
	var current_level = GameState.upgrades[upgrade_names[idx]].level
	if current_level <= 0:
		print("MIN LEVEL")
		return
		
	var current_level_price = GameState.upgrades[upgrade_names[idx]].levels[current_level].price
	earn_price(current_level_price)
	update_resource_indicator()
	GameState.upgrades[upgrade_names[idx]].level -= 1
	GameState.equipment[upgrade_names[idx]] = GameState.upgrades[upgrade_names[idx]].levels[current_level + 1].value
	update_indicator_position($Mothership/Bg/Veins.get_node("Upgrade" + str(idx + 1) + "/Panel/Indicator"), GameState.upgrades[upgrade_names[idx]].level)
	
	
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

func _on_up_input_event(viewport: Node, event: InputEvent, shape_idx: int, idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		var already_visible = $Mothership/Bg/Veins.get_node("Upgrade" + str(idx) + "/Panel").visible
		hide_panels()
		if !already_visible:
			$Mothership/Bg/Veins.get_node("Upgrade" + str(idx) + "/Panel").show()
			$Mothership/Bg/Veins.get_node("Upgrade" + str(idx) + "/Light").enabled = true
		
