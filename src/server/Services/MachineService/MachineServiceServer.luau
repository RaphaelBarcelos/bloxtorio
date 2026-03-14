local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local InventoryServiceServer = require(ServerScriptService.Server.Services.InventoryService.InventoryServiceServer)
local Machines = require(ReplicatedStorage.Shared.Data.Machines)
local Recipes = require(ReplicatedStorage.Shared.Data.Recipes)

print("Miner Extraction:", Machines.Miner.extraction)

local MachineServiceServer = {}

local machines = {}

function MachineServiceServer:createMachine(machineType)
	local data = Machines[machineType]

	local machine = {
		type = machineType,

		recipe = nil,

		outputTarget = nil,

		inventory = {
			input = {},
			output = {},
		},

		inventoryLimits = data.inventory,
	}

	table.insert(machines, machine)

	print("Machine:", machineType)

	return machine
end

function MachineServiceServer:processMachine(machine)
	local data = Machines[machine.type]

	if data.category == "extractor" then
		self:processExtractor(machine)
	elseif data.category == "smelting" then
		self:processSmelting(machine)
	elseif data.category == "crafting" then
		self:processCrafting(machine)
	else
		print("Unknown machine category:", data.category)
	end
end

function MachineServiceServer:processExtractor(machine)
	local data = Machines[machine.type]

	local resource = data.extraction.resource
	local amount = data.extraction.rate

	local current = machine.inventory.output[resource] or 0
	local limit = machine.inventoryLimits.output

	if current < limit then
		InventoryServiceServer:addItem(machine.inventory, "output", resource, amount)
	else
		print("Machine inventory full for resource:", resource)
	end
end

function MachineServiceServer:processSmelting(machine)
	if not machine.recipe then
		print("Machine has no recipe set.")
		return
	end

	local recipe = Recipes[machine.recipe]

	for item, amount in pairs(recipe.input) do
		local current = machine.inventory.input[item] or 0

		if current < amount then
			print("Not enough input for item:", item)
			return
		end
	end

	for item, amount in pairs(recipe.input) do
		InventoryServiceServer:removeItem(machine.inventory, "input", item, amount)
	end

	for item, amount in pairs(recipe.output) do
		InventoryServiceServer:addItem(machine.inventory, "output", item, amount)
		print("Smelted recipe:", machine.recipe)
	end
end

function MachineServiceServer:processCrafting(machine)
	if not machine.recipe then
		print("Machine has no recipe set.")
		return
	end

	local recipe = Recipes[machine.recipe]
	local canCraft = true

	for item, amount in pairs(recipe.input) do
		local current = machine.inventory.input[item] or 0

		if current < amount then
			print("Not enough input for item:", item)
			canCraft = false
			break
		end
	end

	if not canCraft then
		return
	end

	for item, amount in pairs(recipe.input) do
		InventoryServiceServer:removeItem(machine.inventory, "input", item, amount)
	end

	for item, amount in pairs(recipe.output) do
		InventoryServiceServer:addItem(machine.inventory, "output", item, amount)
		print("Produced:", amount, item, "in", machine.type)
	end
end

function MachineServiceServer:setRecipe(machine, recipeName)
	machine.recipe = recipeName
end

function MachineServiceServer:getRecipesForMachine(machineType)
	local data = Machines[machineType]
	local category = data.category
	local recipes = {}

	for recipeName, recipeData in pairs(Recipes) do
		if recipeData.category == category then
			table.insert(recipes, recipeName)
		end
	end

	return recipes
end

function MachineServiceServer:getMachines()
	return machines
end

function MachineServiceServer:printInventory(machine)
	print("INPUT:")
	for item, amount in pairs(machine.inventory.input) do
		print("  ", item, "=", amount)
	end

	print("OUTPUT:")
	for item, amount in pairs(machine.inventory.output) do
		print("  ", item, "=", amount)
	end
end

return MachineServiceServer
