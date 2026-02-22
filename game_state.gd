extends Node

var currrent_planet = {}

var resources = {
	crystal = 22,
	gas = 33,
	iron = 44
}

var equipment = {
	miners = 3,
	ammo = 10,
	shield_level = 0,
	fuel = 1
}

var upgrades = {
	ammo = {
		label = "AMMO",
		level = 0,
		levels = [
			{
				text = "10 shots",
				price = {
					crystal = 10,
					gas = 0,
					iron = 0
				},
				value = 5
			},
			{
				text = "10 shots",
				price = {
					crystal = 10,
					gas = 0,
					iron = 0
				},
				value = 10
			},
			{
				text = "20 shots",
				price = {
					crystal = 10,
					gas = 0,
					iron = 0
				},
				value = 20
			}
		]
	},
	
	shield = {
		label = "SHIELD",
		level = 0,
		levels = [
			{
				text = "front",
				price = {
					crystal = 10,
					gas = 0,
					iron = 0
				},
				value = 0
			},
			{
				text = "full, 2 sec",
				price = {
					crystal = 10,
					gas = 0,
					iron = 0
				},
				value = 2
			},
			{
				text = "full, 5 sec",
				price = {
					crystal = 10,
					gas = 0,
					iron = 0
				},
				value = 5
			}
		]
	},
	
	miners = {
		label = "MINERS",
		level = 0,
		levels = [
			{
				text = "1 miner",
				price = {
					crystal = 10,
					gas = 0,
					iron = 0
				},
				value = 1
			},
			{
				text = "2 miners",
				price = {
					crystal = 10,
					gas = 0,
					iron = 0
				},
				value = 2
			},
			{
				text = "3 miners",
				price = {
					crystal = 10,
					gas = 0,
					iron = 0
				},
				value = 3
			},
			{
				text = "5 miners",
				price = {
					crystal = 10,
					gas = 0,
					iron = 0
				},
				value = 5
			}
		]
	},
	
	fuel = {
		label = "FUEL TANK",
		level = 0,
		levels = [
		{
				text = "ring 1",
				price = {
					crystal = 10,
					gas = 0,
					iron = 0
				},
				value = 1
			},
			{
				text = "ring 2",
				price = {
					crystal = 10,
					gas = 0,
					iron = 0
				},
				value = 2
			},
			{
				text = "ring 3",
				price = {
					crystal = 10,
					gas = 0,
					iron = 0
				},
				value = 3
			}
	]
	},
	
}
