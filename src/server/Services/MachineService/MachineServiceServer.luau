local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local InventoryServiceServer = require(ServerScriptService.Server.Services.InventoryService.InventoryServiceServer)
local Machines = require(ReplicatedStorage.Shared.Data.Machines)

print("Miner Extraction:", Machines.Miner.extraction)

local MachineServiceServer = {}

local machines = {}

function MachineServiceServer:createMachine(machineType)
	local data = Machines[machineType]

	local machine = {
		type = machineType,
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

	print("Machine Type:", machine.type)
	print("Data Category:", data.category)

	if data.category == "extractor" then
		local resource = data.extraction.resource

		print("Machine Data:", Machines[machine.type])

		local amount = data.extraction.rate

		print("Resource: ", resource)
		print("Amount: ", amount)

		InventoryServiceServer:addItem(machine.inventory, "output", resource, amount)

		for item, amount in pairs(machine.inventory.output) do
			print("Inventario:", item, amount)
		end
	end
end

function MachineServiceServer:getMachines()
	return machines
end

return MachineServiceServer
