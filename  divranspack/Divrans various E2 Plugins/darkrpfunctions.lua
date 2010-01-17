AddCSLuaFile("darkrpfunctions.lua")

e2function string entity:shipmentContents()
	if (!validEntity(this) or this:GetClass() != "spawned_shipment") then return "" end
	return this:GetNWString("contents")
end

e2function number entity:shipmentAmount()
	if (!validEntity(this) or this:GetClass() != "spawned_shipment") then return -1 end
	return this:GetNWInt("count")
end

e2function number entity:moneyAmount()
	if (!validEntity(this)) then return -1 end
	if (this:GetTable().MoneyBag) then
		return this:GetTable().Amount
	else
		return -1
	end
end