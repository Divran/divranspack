AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()   
	self.Entity:PhysicsInit( SOLID_VPHYSICS )  	
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Inputs = WireLib.CreateInputs( self.Entity, { "On", "Radius" } )
	
	pewpew:AddSafeZone( Vector(0,0,0), 1000, self.Entity )
	self.On = true
	self.Radius = 1000
end

function ENT:TriggerInput( name, value )

	if (name == "On") then
		if (value != 0) then
			if (!self.On) then
				pewpew:AddSafeZone( Vector(0,0,0), self.Radius, self.Entity )
				self.On = true
			end
		else
			if (self.On) then
				pewpew:RemoveSafeZone( self.Entity )
				self.On = false
			end
		end
	elseif (name == "Radius") then
		value = math.Clamp(value,50,2000)
		if (self.Radius != value) then
			self.Radius = value
			pewpew:ModifySafeZone( self.Entity, Vector(0,0,0), self.Radius, self.Entity )
		end
	end
		
end

function ENT:OnRemove() pewpew:RemoveSafeZone( self.Entity ) end