extends Node


var resources = {
	crystal = 22,
	gas = 33,
	iron = 44
}

var equipment = {
	deploys = 3,
	ammo = 10,
	shield_level = 0
}

var upgrades = {
	ammo = {
		level = 0,
		levels = [
			{
				text = "10 shots",
				price = {
					crystal = 10
				},
				value = 5
			},
			{
				text = "10 shots",
				price = {
					crystal = 10
				},
				value = 10
			},
			{
				text = "20 shots",
				price = {
					crystal = 10
				},
				value = 20
			}
		]
	},
	
	shield = {
		level = 0
	},
	
	miners = {
		level = 0
	},
	
	fuel = {
		level = 0
	},
	
}
