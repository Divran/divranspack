-- Resource Burner
-- Made by Divran

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()
	self.BaseClass.Initialize(self)
	self.BaseClass.RegisterNonStorageDevice(self)
	self:SetNetworkedInt( "overlaymode", 2 )
	WireLib.CreateInputs( self.Entity, { "Resource [STRING]", "Burn" } )
	self.Active = false
	self.Rate = 0
	self.BurnResource = ""
	self:SetNWString("OverlayText", "Resource Burner\nActive: No\nRate: 0\nResource:" )
end

function ENT:CheckValidResource( res )
	local resources = CAF.GetAddon("Resource Distribution").GetAllRegisteredResources()
	if (resources[res]) then return true end
	return false			
end

function ENT:TriggerInput( name, value )
	if (name == "Resource") then
		value = string.lower(value)
		local str = "No"
		if (self.Active) then str = "Yes" end
		local str2 = value
		if (self:CheckValidResource( value )) then
			self.BurnResource = value
		else
			str2 = "Invalid Resource"
		end
		self:SetNWString("OverlayText", "Resource Burner\nActive: " .. str .. "\nRate: "..self.Rate.."\nResource: " .. str2 )
	elseif (name == "Burn") then
		if (value == 0) then
			self.Rate = 0
			self.Active = false
			self:SetNWString("OverlayText", "Resource Burner\nActive: No\nRate: 0\nResource: " .. self.BurnResource )
		else
			self.Rate = value
			self.Active = true
			self:SetNWString("OverlayText", "Resource Burner\nActive: Yes\nRate: "..self.Rate.."\nResource: " .. self.BurnResource )
		end
	end
end

function ENT:SpawnFunction( ply, trace )
	if (!trace or !trace.Hit) then return end
	local ent = ents.Create( "resource_burner" )
	ent:SetPlayer( ply )
	ent:SetPos( trace.HitPos + trace.HitNormal * 50 )
	ent:SetModel( "models/props_combine/suit_charger001.mdl" )
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Think()
	if (self.Active and self.Active == true) then
		if (self.BurnResource and self.BurnResource != "" and self.Rate and self.Rate != 0) then
			local amount = self:GetResourceAmount(self.BurnResource)
			if (amount) then
				self:ConsumeResource(self.BurnResource,math.min(self.Rate,amount))
			end
		end
	end
end
