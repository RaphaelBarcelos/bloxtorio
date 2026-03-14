local ServicerScriptServce = game:GetService("ServerScriptService")
local ItemTransferServiceServer = require(script.Services.ItemTransferService.ItemTransferServiceServer)
local MachineServiceServer = require(script.Services.MachineService.MachineServiceServer)

local miner1 = MachineServiceServer:createMachine("Miner")
local miner2 = MachineServiceServer:createMachine("Miner")

local furnace = MachineServiceServer:createMachine("Furnace")

MachineServiceServer:setRecipe(furnace, "IronPlate")

miner1.outputTarget = furnace
miner2.outputTarget = furnace

while true do
	local machines = MachineServiceServer:getMachines()

	for _, machine in pairs(MachineServiceServer:getMachines()) do
		print("Processando maquina:", machine.type)

		MachineServiceServer:processMachine(machine)
	end

	for i = 1, #machines - 1 do
		local source = machines[i]
		local target = machines[i + 1]

		print("Transferring from", source.type, "to", target.type)
		ItemTransferServiceServer:transfer(source, target)
	end

	print("\n===== MACHINE TICK =====")

	print("\n--- MINERS ---")

	for i, machine in ipairs(machines) do
		if machine.type == "Miner" then
			print("Miner #" .. i)
			MachineServiceServer:printInventory(machine)
		end
	end

	print("\n--- FURNACE ---")

	for i, machine in ipairs(machines) do
		if machine.type == "Furnace" then
			print("Furnace #" .. i)
			MachineServiceServer:printInventory(machine)
		end
	end

	print("\n========================")

	task.wait(1)
end
