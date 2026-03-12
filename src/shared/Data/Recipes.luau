local Recipes = {

	IronPlate = {
		category = "smelting",
		input = { IronOre = 1 },
		output = { IronPlate = 1 },
		time = 2,
	},

	Gear = {
		category = "crafting",
		input = { IronPlate = 2 },
		output = { Gear = 1 },
		time = 1,
	},
}

return Recipes
