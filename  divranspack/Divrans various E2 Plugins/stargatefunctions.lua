AddCSLuaFile('stargatefunctions.lua')

-- Stargate Functions by Divran

----- STARGATE

-- Gets the address of the stargate
__e2setcost(5)
e2function string entity:sgAddress()
	if !validEntity(this) or !this.IsStargate then return "" end
	return this:GetGateAddress()
end

-- Sets the address of the stargate
__e2setcost(10)
e2function number entity:sgSetAddress( string address )
	if !validEntity(this) or !isOwner(self, this) or !this.IsStargate then return 0 end
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
	if !validEntity(this) or !this.IsStargate then return "" end
	return this:GetGateName()
end

-- Sets the name of the stargate
__e2setcost(10)
e2function number entity:sgSetName( string name )
	if !validEntity(this) or !isOwner(self, this) or !this.IsStargate then return 0 end
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
	if !validEntity(this) or !isOwner(self, this) or !this.IsStargate then return nil end
	this:DialGate(string.upper(address),util.tobool(mode))
end

-- Dial the gate (with entity input)
__e2setcost(10)
e2function void entity:sgDial(entity target, number mode)
	if !validEntity(this) or !isOwner(self, this) or !this.IsStargate or !target.IsStargate or target:GetGateAddress() == nil or target:GetGateAddress() == "" or this == target then return nil end
	this:DialGate(target:GetGateAddress(), util.tobool(mode))
end

-- Abort dialing
__e2setcost(10)
e2function void entity:sgAbort()
	if !validEntity(this) or !isOwner(self, this) or !this.IsStargate  then return nil end
	this:AbortDialling()
end

-- Check if blocked
__e2setcost(15)
e2function number entity:sgBlockedByIris()
	if !validEntity(this) or !this.IsStargate then return 0 end
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
	if !validEntity(this) or !isOwner(self, this) or !this.IsStargate then return nil end
	this:SetPrivate(bool)
end

-- Get Private
__e2setcost(5)
e2function number entity:sgPrivate()
	if !validEntity(this) or !isOwner(self, this) or !this.IsStargate then return -1 end
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
	if !validEntity(this) or !this.IsStargate then return nil end
	return this.Target
end

	-- Status
-- Open
__e2setcost(4)
e2function number entity:sgOpen()
	if !validEntity(this) or !this.IsStargate then return -1 end
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
	if !validEntity(this) or !this.IsStargate then return -1 end
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
	if !validEntity(this) or !this.IsStargate then return -1 end
	local ret = this.Active
	if (ret) then
		return 1
	else
		return 0
	end
end

----- ASGARD
__e2setcost(15)
e2function void entity:sgAsgardSend( vector origin, vector destination, number sendall )
	if !validEntity(this) or this:GetClass() != "transporter" or !isOwner(self, this) then return nil end
	this.TeleportEverything = util.tobool(sendall)
	this:Teleport( origin, destination )
end

----- RINGS
__e2setcost(10)
e2function void entity:sgRingDialClosest()
	if !validEntity(this) or this:GetClass() != "ring_base" or !isOwner(self, this) or this.Busy then return nil end
	this:Dial("")
end

__e2setcost(10)
e2function void entity:sgRingDial( string address )
	if !validEntity(this) or this:GetClass() != "ring_base" or !isOwner(self, this) or this.Busy then return nil end
	this:Dial( address )
end

__e2setcost(4)
e2function string entity:sgRingAddress()
	if !validEntity(this) or this:GetClass() != "ring_base" then return "" end
	return this.Address or ""
end

__e2setcost(10)
e2function number entity:sgRingSetAddress( string address )
	if !validEntity(this) or this:GetClass() != "ring_base" or !isOwner(self, this) or this.Busy then return 0 end
	self.RingNameEnt = this
	RingsNamingCallback( self, "", { address } )
	return 1
end

__e2setcost(nil)