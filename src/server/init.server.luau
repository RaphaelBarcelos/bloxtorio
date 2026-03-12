local ServicerScriptServce = game:GetService("ServerScriptService")
local MachineServiceServer = require(script.Services.MachineService.MachineServiceServer)

MachineServiceServer:createMachine("Miner")
MachineServiceServer:createMachine("Miner")

while true do
	for _, machine in pairs(MachineServiceServer:getMachines()) do
		print("Processando maquina:", machine.type)

		MachineServiceServer:processMachine(machine)
	end

	task.wait(1)
end
