AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()   
	self.Entity:PhysicsInit( SOLID_VPHYSICS )  	
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )      

	self.Outputs = Wire_CreateOutputs( self.Entity, { "Health", "Total Health" })
	
	self.pewpew = {}
	self.Props = {}
	self.PropHealth = {}
	self.pewpew.CoreHealth = 1
	self.pewpew.CoreMaxHealth = 1
	self.Entity.Core = self
	
	Wire_TriggerOutput( self.Entity, "Health", self.pewpewCoreHealth or 0 )
	Wire_TriggerOutput( self.Entity, "Total Health", self.pewpewCoreMaxHealth or 0 )
	
	self.Entity:NextThink( CurTime() + 1 )
	return true
end

function ENT:SetOptions( ply )
	self.Owner = ply
end

function ENT:ClearProp( Entity )
	for key, ent in pairs( self.Props ) do
		if (Entity == ent) then
			table.remove( self.Props, key )
			self.Prophealth[ent:EntIndex()] = nil
		end
	end
end

function ENT:Think()
	-- Get all constrained props
	self.Props = constraint.GetAllConstrainedEntities( self.Entity )
	
	-- Loop through all props
	local hp = self.pewpewCoreHealth
	local maxhp = 1
	for _, ent in pairs( self.Props ) do
		if (ent and pewpew:CheckValid( ent ) and pewpew:CheckAllowed( ent )) then
			local health = self.PropHealth[ent:EntIndex()] or 0
			local enthealth = pewpew:GetHealth( ent )
			if (!ent.Core or !pewpew:CheckValid(ent.Core)) then -- if the entity has no core
				ent.Core = self.Entity
				self.PropHealth[ent:EntIndex()] = enthealth
				hp = hp + enthealth
			elseif (ent.Core and pewpew:CheckValid(ent.Core) and ent.Core == self.Entity and enthealth != health) then -- if the entity's health has changed
				hp = hp - health -- subtract the old health
				hp = hp + enthealth -- add the new health
				self.PropHealth[ent:EntIndex()] = enthealth
			elseif (ent.Core and pewpew:CheckValid( ent.Core ) and ent.Core != self.Entity) then -- if the entity already has a core
				self.Owner:ChatPrint("You cannot have several cores in the same contraption. Core self-destructing.")
					local effectdata = EffectData()
					effectdata:SetOrigin( self.Entity:GetPos() )
					effectdata:SetScale( (self.Entity:OBBMaxs() - self.Entity:OBBMins()):Length() )
					util.Effect( "pewpew_deatheffect", effectdata )
				self:Remove()
				return
			end
			maxhp = maxhp + enthealth
		end
	end
	-- Set health
	self.pewpewCoreHealth = hp
	self.pewpewCoreMaxHealth = maxhp
	
	
	-- Set NW ints
	hp = self.Entity:GetNWInt("pewpewMaxHealth")
	if (!hp or hp != self.pewpewCoreMaxHealth) then
		self.Entity:SetNWInt("pewpewMaxHealth", self.pewpewCoreMaxHealth)
	end
	hp = self.Entity:GetNWInt("pewpewHealth")
	if (!hp or hp != self.pewpewCoreHealth) then
		self.Entity:SetNWInt("pewpewHealth", self.pewpewCoreHealth)
	end
	
	-- Wire Output
	Wire_TriggerOutput( self.Entity, "Health", self.pewpewCoreHealth or 0 )
	Wire_TriggerOutput( self.Entity, "Total Health", self.pewpewCoreMaxHealth or 0 )
	
	-- Run again in 1 second
	self.Entity:NextThink( CurTime() + 1 )
	return true
end

function ENT:RemoveAllProps()
	for _, ent in pairs( self.Props ) do
		local effectdata = EffectData()
		effectdata:SetOrigin( ent:GetPos() )
		effectdata:SetScale( (ent:OBBMaxs() - ent:OBBMins()):Length() )
		util.Effect( "pewpew_deatheffect", effectdata )
		ent:Remove()
	end
	self:Remove()
end