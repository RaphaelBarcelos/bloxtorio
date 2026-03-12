local InventoryServiceServer = {}

function InventoryServiceServer:addItem(inventory, section, item, amount)
	inventory[section][item] = (inventory[section][item] or 0) + amount
end

function InventoryServiceServer:removeItem(inventory, section, item, amount)
	if not inventory[section][item] then
		return false
	end

	inventory[section][item] = inventory[section][item] - amount

	if inventory[section][item] <= 0 then
		inventory[section][item] = nil
	end

	return true
end

function InventoryServiceServer:hasItem(inventory, section, item, amount)
	local count = inventory[section][item] or 0
	return count >= amount
end

function InventoryServiceServer:getItemCount(inventory, section, item)
	return inventory[section][item] or 0
end

function InventoryServiceServer:canAddItem(inventory, section, limit)
	local total = 0

	for _, amount in pairs(inventory[section]) do
		total = total + amount
	end

	return total < limit
end

return InventoryServiceServer
