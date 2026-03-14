local ItemTransferServiceServer = {}

function ItemTransferServiceServer:transfer(sourceMachine, targetMachine)
	for item, amount in pairs(sourceMachine.inventory.output) do
		if amount > 0 then
			sourceMachine.inventory.output[item] -= 1

			targetMachine.inventory.input[item] = (targetMachine.inventory.input[item] or 0) + 1
			print("Transferred 1", item, "from", sourceMachine.type, "to", targetMachine.type)
			break
		end
	end
end

return ItemTransferServiceServer
