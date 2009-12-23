-- Stargate Functions by Divran
if (CLIENT) then
	-- I couldn't get these working. Oh well.
	E2Helper.Descriptions["sgAddress(e)"] = "Gets the address."
	E2Helper.Descriptions["sgSetAddress(e:s)"] = "Sets the address."
	E2Helper.Descriptions["sgName(e)"] = "Gets the name."
	E2Helper.Descriptions["sgSetName(e:s)"] = "Sets the name."
	E2Helper.Descriptions["sgDial(e:sn)"] = "Causes the gate to dial to the address, with a number input for dial mode (fast/slow)."
	E2Helper.Descriptions["sgAbort(e)"] = "Closes the gate and aborts the dialing sequence."
	E2Helper.Descriptions["sgSetPrivate(e:n)"] = "Set the gate's private state."
	E2Helper.Descriptions["sgPrivate(e)"] = "Gets the gate's private state."
	E2Helper.Descriptions["sgBlockedByIris(e)"] = "Checks if the gate is blocked by an iris. Only works if the gate has an established wormhole (aVoN made it that way)."
	E2Helper.Descriptions["sgTarget(e)"] = "Returns the connected gate."
	E2Helper.Descriptions["sgActive(e)"] = "Returns 1 if the gate is active.."
	E2Helper.Descriptions["sgOpen(e)"] = "Returns 1 if the gate is open."
	E2Helper.Descriptions["sgInbound(e)"] = "Returns 1 if the current wormhole is inbound.")
end



-- Gets the address of the stargate
__e2setcost(5)
e2function string entity:sgAddress()
	if !validEntity(this) then return "" end
	return this:GetGateAddress()
end

-- Sets the address of the stargate
__e2setcost(10)
e2function number entity:sgSetAddress( string address )
	if !validEntity(this) then return 0 end
	if !isOwner(self, this) then return 0 end
	local oldaddress = this:GetGateAddress()
	this:SetGateAddress(address)
	local newaddress = this:GetGateAddress()
	if (oldaddress != newaddress) then
		return 1
	else
		return 0
	end
end

-- Gets the name of the stargate
__e2setcost(5)
e2function string entity:sgName()
	if !validEntity(this) then return "" end
	return this:GetGateName()
end

-- Sets the name of the stargate
__e2setcost(10)
e2function number entity:sgSetName( string name )
	if !validEntity(this) then return 0 end
	if !isOwner(self, this) then return 0 end
	local oldname = this:GetGateName()
	this:SetGateName( name )
	local newname = this:GetGateName()
	if (oldname != newname) then
		return 1
	else
		return 0
	end
end

-- Dial the gate
__e2setcost(10)
e2function void entity:sgDial(string address, number mode)
	if !validEntity(this) then return nil end
	if !isOwner(self, this) then return nil end
	this:DialGate(string.upper(address),mode)
end

-- Abort dialing
__e2setcost(10)
e2function void entity:sgAbort()
	if !validEntity(this) then return nil end
	if !isOwner(self, this) then return nil end
	this:AbortDialling()
end

-- Check if blocked
__e2setcost(15)
e2function number entity:sgBlockedByIris()
	if !validEntity(this) then return nil end
	local ret = this:IsBlocked(1)
	if (ret) then
		return 1
	else
		return 0
	end
end

-- Set Private
__e2setcost(10)
e2function void entity:sgSetPrivate( number bool )
	if !validEntity(this) then return nil end
	if !isOwner(self, this) then return nil end
	this:SetPrivate(bool)
end

-- Get Private
__e2setcost(5)
e2function number entity:sgPrivate()
	if !validEntity(this) then return nil end
	if !isOwner(self, this) then return nil end
	local ret = this:GetPrivate()
	if (ret) then
		return 1
	else
		return 0
	end
end

-- Get Target
__e2setcost(4)
e2function entity entity:sgTarget()
	if !validEntity(this) then return nil end
	return this.Target
end

	-- Status
-- Open
__e2setcost(4)
e2function number entity:sgOpen()
	if !validEntity(this) then return nil end
	local ret = this.IsOpen
	if (ret) then
		return 1
	else
		return 0
	end
end

-- Inbound
__e2setcost(4)
e2function number entity:sgInbound()
	if !validEntity(this) then return nil end
	local ret = !this.Outbound and this.Active
	if (ret) then
		return 1
	else
		return 0
	end
end

-- Active
__e2setcost(4)
e2function number entity:sgActive()
	if !validEntity(this) then return nil end
	local ret = this.Active
	if (ret) then
		return 1
	else
		return 0
	end
end

__e2setcost(nil)