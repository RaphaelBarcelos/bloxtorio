local Machines = {
	Miner = {
		name = "Miner",

		category = "extractor",
		size = { x = 2, y = 2 },

		extraction = {
			resource = "IronOre",
			rate = 1,
			time = 2,
		},

		inventory = {
			input = 0,
			output = 20,
		},
	},

	Furnace = {
		name = "Furnace",

		category = "smelting",
		size = { x = 2, y = 2 },

		inventory = {
			input = 10,
			output = 10,
		},

		speed = 1,
	},

	Assembler = {
		name = "Assembler",

		category = "crafting",
		size = { x = 2, y = 2 },

		inventory = {
			input = 20,
			output = 10,
		},

		speed = 1.5,
	},
}

return Machines
